module Chess
  class Bishop < Piece
    include Validator::Slidable::Diagonal
    attr_reader :name

    def initialize color, current_position
      super(color, current_position)
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
