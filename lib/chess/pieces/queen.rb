module Chess
  class Queen < Piece
    attr_reader :name

    def initialize color, current_position, board
      super(color, current_position, board)
      @name = :queen
    end
    def move!
      super
      basic_move
    end

    def possible_moves
        straight_moves.concat(diagonal_moves)
    end
    
    private
      include Actionable::Slidable::Straight
      include Actionable::Slidable::Diagonal
      def assign_symbol
        color == :white ? "♕" : "♛"
      end
  end
end