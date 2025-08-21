module Chess
  class Bishop < Piece
    include Validatable::Slidable::Diagonal
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
    
    def assign_symbol
      color == :white ? "♗" : "♝"
    end
  end
end
