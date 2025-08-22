require_relative "./gamestate/gamestate"
require_relative "validatable"
require_relative "unpackable"

module Chess
  class Board
    include Gamestate::Check
    include Gamestate::Checkmate
    include Validatable
    attr_accessor :grid, :captured_pieces, :current_player_color
    alias_method :color, :current_player_color
    
    def initialize
      @grid = Array.new(8) { Array.new(8) }
      @captured_pieces = []
      @moves = []
      populate_board
    end
    
    def update! piece, last_position, destination_position
      add_to_cell(destination_position, piece)
      clear_cell(last_position)
      @moves << destination_position

      #removing the marked enpassant square from the board if not attacked
      # if marked square and the color id != than color
      #  Rememberable.forget(enpassant)
      # end
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
    def king
      pieces.select(&current_king).first
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
      @grid[position[0]][position[1]] = nil
    end
    def add_to_cell position, piece
      @grid[position[0]][position[1]] = piece
    end
    def [] x, y
      @grid[x][y]
    end
    def dup
      Marshal.load(Marshal.dump(self))
    end

    private
    include Unpackable
    def populate_board
      @grid = Array.new(8) { Array.new(8) }

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
      # @grid[1] = Array.new(8) { |i| nil }
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
      # @grid[6] = Array.new(8) { |i| nil }
    end
    def current_king
      proc {|piece| piece.is_a?(King) && piece.color == color }
    end
  end
end