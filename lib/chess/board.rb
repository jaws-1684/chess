require_relative "./gamestate/gamestate"
require_relative "validatable"
require_relative "unpackable"
require_relative "rememberable"
require_relative "displayable"


module Chess
  class Board
    include Gamestate::Check
    include Gamestate::Checkmate
    include Validatable
    attr_reader :rememberable, :squares_under_attack
    attr_accessor :grid, :captured_pieces, :current_player_color
    alias_method :color, :current_player_color
    
    def initialize memo=Rememberable.new
      @grid = Array.new(8) { Array.new(8) }
      @captured_pieces = []
      @moves = []
      @rememberable = memo
      @squares_under_attack = []
      populate_board
    end
    
    def update! piece, last_position, destination_position
      render(@grid)

      add_to_cell(destination_position, piece)
      render(@grid)
      clear_cell(last_position)
      @moves << destination_position

      #removing the marked enpassant square from the board in the next opponent move regardless is its attacked or not
      #also ensuring that the enpassant_vulnerable flag is reset
      handle_enpassant! if enpassant_pawn_exists?
    end
    def select_square position
      unpack(position) { |x, y| self[x, y] }
    end
    def get_piece position
      raise "Invalid position: #{position}" unless valid_position?(position)
      raise "Invalid selection: #{position}. You cannot select an empty square!" if clear_destination?(position)
      piece = select_square(position)
      raise "You can select only #{color} pieces!" unless piece.color == color 
      piece
    end
    def pieces
      grid.flatten.compact
    end
    def enemies
      pieces.reject { |piece| piece.color == color }
    end
    def players_pieces
      pieces.select {|piece| piece.color == color }
    end
    def king_position
      rememberable.dig("#{color}_king", :position)
    end
    def mark_squares_under_attack!
      0.upto(7) do |i|
        0.upto(7) do |j|
          @squares_under_attack << [i, j] if enemies.any? { |enemy| enemy.can_attack?([i, j]) }
        end
      end
    end
    def to_marshal
      {
        grid: @grid,
        captured_pieces: @captured_pieces
      }
    end

    def self.from_marshal data
      @grid = data[:grid]
      @captured_pieces = data[:captured_pieces]
    end
    def clear_cell position
      grid[position[0]][position[1]] = nil
    end
    def add_to_cell position, piece
      grid[position[0]][position[1]] = piece
    end
    def [] x, y
      grid[x][y]
    end
    def dup
      Marshal.load(Marshal.dump(self))
    end

    private
    include Unpackable
    def populate_board
      @grid[0] = [
        Rook.new(:white, [0, 0], self),
        Knight.new(:white, [0, 1], self),
        Bishop.new(:white, [0, 2], self),
        Queen.new(:white,  [0, 3], self),
        King.new(:white,   [0, 4], self),
        Bishop.new(:white, [0, 5], self),
        Knight.new(:white, [0, 6], self),
        Rook.new(:white,   [0, 7], self)
      ]
      @grid[1] = Array.new(8) { |i| Pawn.new(:white, [1, i], self) }
      @grid[7] = [
        Rook.new(:black,   [7, 0], self),
        Knight.new(:black, [7, 1], self),
        Bishop.new(:black, [7, 2], self),
        Queen.new(:black,  [7, 3], self),
        King.new(:black,   [7, 4], self),
        Bishop.new(:black, [7, 5], self),
        Knight.new(:black, [7, 6], self),
        Rook.new(:black,   [7, 7], self)
      ]
      @grid[6] = Array.new(8) { |i| Pawn.new(:black, [6, i], self) }
    end
    def handle_enpassant!
      pawn_position = rememberable.dig(:enpassant_pawn, :current_square)
      pawn = select_square(pawn_position)

      pawn.enpassant_vulnerable = false if pawn
      rememberable.destroy!(:enpassant_pawn)
    end
    def enpassant_pawn_exists?
      rememberable[:enpassant_pawn] && rememberable[:enpassant_pawn][:color] != current_player_color
    end
  end
end