module Chess
  class Queen < Piece
    include Validator::Slidable::All
    attr_reader :name

    def initialize color, current_position
      super(color, current_position)
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