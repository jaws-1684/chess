module Chess
  class Pawn < Piece
    include Validator::Pawn
    attr_reader :name, :first_move, :direction

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
        if enpassant_vulnerable_move?
          set_enpassant_flag        
          generate_temporary_pawn!
        else
          reset_enpassant_flag  
        end
        @first_move = false 
      end
    end

    def attack!
      super
      basic_attack do
        reset_enpassant_flag
        if !!enemy&.enpassant_vulnerable
          board.clear_cell([dx-direction, dy])
        end
        @first_move = false 
      end    
    end

    def enpassant_vulnerable_move?
      destination_position == double_step
    end
    def set_enpassant_flag
      @enpassant_vulnerable = true
    end
    def reset_enpassant_flag
      @enpassant_vulnerable = false
    end
 
    private
      def assign_symbol
        color == :white ? "♙" : "♟"
      end
      def generate_temporary_pawn!
        temporary_pawn = Pawn.new(self.color, [dx-direction, dy])
        temporary_pawn.enpassant_vulnerable = true
        temporary_pawn.symbol = self.symbol.colorize(:red)
        board.temporary_pawn = temporary_pawn
        board.add_to_cell([dx-direction, dy], temporary_pawn)
      end
  end
end
