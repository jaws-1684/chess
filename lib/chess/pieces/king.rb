module Chess
  module Castle
    def rook place
      positions = {
        queenside: 0,
        kingside: 7
      }
      piece = board[px, positions[place]]
      piece if piece.is_a?(Rook) && piece.friendly?(self)
    end
    def rook_move! type, &block
      rook(type).board = board
      rook(type).destination_position = yield
      rook(type).move!
    end
    def castle_move?
      (destination_position == possible_moves.kingside_castle) || 
        (destination_position == possible_moves.queenside_castle)
    end
    def valid_castle? type
      !self.has_moved && (rook(type) != nil) && !rook(type).has_moved
    end
    def castle!
      case destination_position
        when possible_moves.kingside_castle
          rook_move!(:kingside) { [px, 5] }
        when possible_moves.queenside_castle
          rook_move!(:queenside) { [px, 3] }
      end
    end
    
  end

  class King < Piece
    include Validatable::Adjoinable
    attr_reader :name, :has_moved 

    def initialize color, current_position, board
      super(color, current_position, board)
      @name = :king
      @has_moved = false
    end
    def move!
      super
      basic_move do
        castle! if castle_move?
        @has_moved = true
      end
    end

    private
      include Castle
      def assign_symbol
        color == :white ? "♔" : "♚"
      end
      
  end
end