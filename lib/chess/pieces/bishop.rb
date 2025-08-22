module Chess
  class Bishop < Piece
    include Actionable::Slidable::Diagonal
    attr_reader :name
    alias_method :possible_moves, :diagonal_moves

    def initialize color, current_position, board
      super(color, current_position, board)
      @name = :bishop
    end

    def move!
      super
      basic_move
    end
      private
      def assign_symbol
        color == :white ? "♗" : "♝"
      end
  end
end
