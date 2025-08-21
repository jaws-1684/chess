module Chess
  class Queen < Piece
    include Validatable::Slidable::All
    attr_reader :name

    def initialize color, current_position, board
      super(color, current_position, board)
      @name = :queen
    end
    def move!
      super
      basic_move
    end
    private
    
    def assign_symbol
      color == :white ? "♕" : "♛"
    end

  end
end