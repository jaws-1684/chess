module Chess
  class Rook < Piece
    include Validator::Slidable::Straight
    attr_reader :name,:has_moved 
    
    def initialize color, current_position
      super(color, current_position)
      @name = :rook
      @has_moved = false
    end
    def move!
      super
      basic_move { @has_moved = true }
    end
    private
    
    def assign_symbol
      color == :white ? "♖" : "♜"
    end
  end
end

