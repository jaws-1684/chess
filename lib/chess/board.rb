require_relative "./gamestate/gamestate"
require_relative "utilities"
require_relative "rememberable"
require_relative "algebraic_notation"

module Chess
  class Board
    include Gamestate::Check
    include Gamestate::Checkmate
    include Utilities::Validatable
    using AlgebraicRefinements
    attr_reader :grid, :rememberable, :squares_under_attack
    attr_accessor :captured_pieces, :current_player_color, :computer
    alias_method :color, :current_player_color
    

    def initialize memo=Rememberable.new, data=Array.new(8) { Array.new(8) { nil } }, chess_set:true
      @grid = data
      populate_board if chess_set
      @squares_under_attack = {}
      @captured_pieces = []
      @moves = []
      @rememberable = memo
      @computer = false
    end
    
    def update! piece, last_position, destination_position
      add_to_cell(destination_position, piece)
      clear_cell(last_position)
      @moves << destination_position
      #removing the marked enpassant square from the board in the next opponent move regardless is its attacked by a pawn or not
      #when the opponent is remove by a pawn this code wont run case the pawn was already removed from the board and the rememberable record deleted
      #also ensuring that the enpassant_vulnerable flag is reset
      handle_enpassant! if enpassant_pawn_exists?
      set_squares_under_attack!(update: true)
    end
    def square_under_attack? square
      squares_under_attack.dig(square, :status) || false
    end

    def set_squares_under_attack! update: false
     pieces = update ?  players_pieces : enemies

     @squares_under_attack = {} 
     pieces.each do |piece|
      if piece.name == :pawn
        pawn_attack_vectors = piece.possible_moves[2..3].select {|pos| valid_position?(pos) }
        if pawn_attack_vectors.any?
          pawn_attack_vectors.each {|v|  @squares_under_attack[v] = { status: true, attacker: piece.name, apos: piece.current_position } }
        end
        next      
      end
        piece.valid_moves.each do |move|
          @squares_under_attack[move] = { 
            status: true,
            attacker: piece.name,
            apos: piece.current_position
          }
        end
      end
    end
    def select_square position
      unpack(position) { |x, y| self[x, y] }
    end
    def get_piece position
      raise "Invalid position: #{position.to_algebraic}" unless valid_position?(position)
      raise "Invalid selection: #{position.to_algebraic}. You cannot select an empty square!" if clear_destination?(position)
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
      rememberable.dig("#{color}_king", :position) || find_current_king
    end

    def to_marshal
      {
        grid: @grid,
        captured_pieces: @captured_pieces,
        moves: @moves,
        rememberable: @rememberable,
        squares_under_attack: @squares_under_attack
      }
    end

    def self.from_marshal data
      @grid = data[:grid]
      @captured_pieces = data[:captured_pieces]
      @moves = data[:moves]
      @rememberable = data[:rememberable]
      @squares_under_attack = data[:squares_under_attack]
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
      include Utilities::Unpackable
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
         @grid[1] = Array.new(8) { |i| Pawn.new(:black, [1, i], self) }
      end
      def handle_enpassant!
        pawn_position = rememberable.dig(:enpassant_pawn, :current_square)
        piece = select_square(pawn_position)
        #this line may be rendundant but its here if something goes wrong
        #it should be a pawn at this position if its not attacked
        piece.enpassant_vulnerable = false if piece&.name == :pawn
        rememberable.destroy!(:enpassant_pawn)
      end
      def enpassant_pawn_exists?
        rememberable[:enpassant_pawn] && rememberable[:enpassant_pawn][:color] != current_player_color
      end
      def find_current_king
        king = pieces.select { |piece| piece&.color == color && piece&.name == :king }.first
        if king
          rememberable.memoize("#{color}_king", position: king.current_position)
          return king.current_position
        end 
      end
  end
end