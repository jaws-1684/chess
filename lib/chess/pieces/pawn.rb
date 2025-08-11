module Chess
  class Pawn < Piece
    include Validator::Pawn
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
        if enpassant_vulnerable?        
          generate_temporary_pawn!
        end
        @first_move = false 
      end
    end

    def attack!
      super
      basic_attack do
        enpassant_vulnerable?
        if !!enemy&.enpassant_vulnerable
          board.clear_cell([dx-direction, dy])
        end
        @first_move = false 
      end
      binding.pry    
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
       def enpassant_vulnerable?
        (destination_position == double_step) ? @enpassant_vulnerable = true : @enpassant_vulnerable = false
        @enpassant_vulnerable
      end
  end
end
