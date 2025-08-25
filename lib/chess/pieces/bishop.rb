module Chess
  class Bishop < Piece
    attr_reader :name

    def initialize color, current_position, board
      super(color, current_position, board)
      @name = :bishop
    end

    def move!
      super
      basic_move
    end
      private
      include Actionable::Slidable::Diagonal
      def assign_symbol
        color == :white ? "♗" : "♝"
      end
      alias_method :possible_moves, :diagonal_moves
  end
end
