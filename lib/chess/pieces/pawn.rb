module Chess
  module Enpassant
     def enpassant_vulnerable_move?
      first_move && destination_position == possible_moves.double_step
    end
    def set_enpassant_flag
      @enpassant_vulnerable = true
    end
    def reset_enpassant_flag
      @enpassant_vulnerable = false
    end
    def generate_temporary_pawn!
      temporary_pawn = Pawn.new(self.color, [dx-direction, dy])
      temporary_pawn.enpassant_vulnerable = true
      temporary_pawn.symbol = self.symbol.colorize(:red)
      board.temporary_pawn = temporary_pawn
      board.add_to_cell([dx-direction, dy], temporary_pawn)
    end
    def enpassant_action
      if enpassant_vulnerable_move?
        set_enpassant_flag        
        generate_temporary_pawn!
      else
        reset_enpassant_flag  
      end
      board.clear_cell([dx-direction, dy]) if !!enemy&.enpassant_vulnerable
    end
  end

  class Pawn < Piece
    include Validator::Stepable
    attr_reader :name, :first_move, :direction
    attr_accessor :enpassant_vulnerable
    def initialize color, current_position
      super(color, current_position)
      @name = :pawn
      @direction = (color == :white) ? 1 : -1
      @first_move = true
      @enpassant_vulnerable = false
    end

    def move!
      super
      basic_move do
        enpassant_action
        @first_move = false 
      end
    end

    private
      include Enpassant
      def assign_symbol
        color == :white ? "♙" : "♟"
      end
  end
end

