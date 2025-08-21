module Chess
  class Knight < Piece
    include Validatable::Lshapable
    attr_reader :name

    def initialize color, current_position, board
      super(color, current_position, board)
      @name = :knight
    end

    def move!
      super
      basic_move
    end
    private
    
    def assign_symbol
      color == :white ? "♘" : "♞"
    end
  end
end