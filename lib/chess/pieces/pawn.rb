module Chess
  class Pawn < Piece
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
      basic_action do
        puts "Moving to #{destination_position}."
        if enpassant_vulnerable?        
          clone_pawn!
        end
        @first_move = false 
      end
    end

    def attack!
      super
      basic_action do
        puts "Attacking #{destination_position}."
        if enemy.enpassant_vulnerable
          binding.pry
          board.clear_cell([dx-direction, dy])
        end
        @first_move = false 
      end    
    end

    def enpassant_vulnerable?
      (destination_position == double_step) ? @enpassant_vulnerable = true : @enpassant_vulnerable = false
      @enpassant_vulnerable
    end
 
    private
      include Validator::Pawn
      def assign_symbol
        color == :white ? "♙" : "♟"
      end
      def clone_pawn!
        cloned_pawn = Pawn.new(:red, [dx-direction, dy])
        cloned_pawn.enpassant_vulnerable = true
        cloned_pawn.symbol = self.symbol.colorize(:red)
        board.add_to_cell([dx-direction, dy], cloned_pawn)
      end
  end
end
