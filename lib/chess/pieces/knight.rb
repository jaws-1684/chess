module Chess
  class Knight < Piece
    include Validator::Lshapable
    attr_reader :name

    def initialize color, current_position
      super(color, current_position)
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