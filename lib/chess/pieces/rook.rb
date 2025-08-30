module Chess
  class Rook < Piece
    attr_reader :name,:has_moved, :score
    alias_method :has_moved?, :has_moved
    
    def initialize color, current_position, board
      super(color, current_position, board)
      @name = :rook
      @has_moved = false
      @score = 9
    end
    def move!
      super
      basic_move { @has_moved = true }
    end
    
    private
      include Actionable::Slidable::Straight
      def assign_symbol
        color == :white ? "♖" : "♜"
      end
      alias_method :possible_moves, :straight_moves 
  end
end