require_relative "../rememberable"

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
      rook(type).destination_position = yield
      rook(type).move!
    end

    def safe_adjacent_square? type
      #checking only the px+1 right and px-1 left squares cause the destination position is checked in the superclass and 
      #the rook itself checks if its putting the king in check
      squares = {
        left: [px, py-1],
        right: [px, py+1]
      }
      case type
        when :kingside
           !board.square_under_attack?(squares[:right])
        when :queenside
           !board.square_under_attack?(squares[:left])
      end      
    end

    def kingside_castle
      [px, py+2]
    end
    def queenside_castle
      [px, py-2]
    end
    def castle_move?
      (destination_position == kingside_castle) || (destination_position == queenside_castle)
    end
    def valid_castle? type
      #returns false if king is under attack
      return false if board.square_under_attack?(current_position) 
      !self.has_moved? && (rook(type) != nil) && !rook(type).has_moved? && safe_adjacent_square?(type)
    end
    def castle!
      case destination_position
        when kingside_castle
          rook_move!(:kingside) { [px, 5] }
        when queenside_castle
          rook_move!(:queenside) { [px, 3] }
      end
    end
    
  end

  class King < Piece
    attr_reader :name, :has_moved 
    alias_method :has_moved?, :has_moved

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
    def basic_move board=self.board, &block
      super(board) do
        board.rememberable.memoize("#{self.color}_king", position: destination_position)
        block.call if block_given?
      end
    end

    private
      include Castle
      include Actionable::Adjoinable
      def assign_symbol
        color == :white ? "♔" : "♚"
      end
      
  end
end