module Chess
  module Enpassant
    def enpassant_vulnerable_move?
      first_move && destination_position == double_step
    end
    def adjacent_pieces
      [piece([px, py+1]), piece([px, py-1])]
    end
    def valid_enpassant_attack?
      adjacent_pieces.any? { |piece| piece.is_a?(Pawn) && piece&.enemy?(self) && piece&.enpassant_vulnerable? }
    end
    def enpassant_capture?
      #checking the passed square
      #if there is no enpassant pawn this will return nil or true
      destination_position == board.rememberable.dig(:enpassant_pawn, :passed_square)
    end
    def enpassant_enemy
      #getting the actual enemy piece to be captured
      position = board.rememberable.dig(:enpassant_pawn, :current_square)
      piece(position)
    end
    def destroy_enemy!
      board.clear_cell(enpassant_enemy.current_position)
    end
  end
  module Promotion
    def final_row?
      color == :black ? px == 0 : px == 7
    end
    def promote!
      puts "Select a piece you want (Q/B/K/R):\s".colorize(:green)
      inp = gets.chomp.downcase
      piece = nil
      case inp
        when "q"
          piece = Queen.new(self.color, [px, py], self.board)
        when "b"
          piece = Bishop.new(self.color, [px, py], self.board)
        when "k"
          piece = Knight.new(self.color, [px, py], self.board)
        when "r"
          piece = Rook.new(self.color, [px, py], self.board)
        else
          piece = self           
      end
      board.update!(piece, last_position, current_position)
    end
  end

  class Pawn < Piece
    attr_reader :name, :first_move, :direction
    attr_accessor :enpassant_vulnerable
    alias_method :enpassant_vulnerable?, :enpassant_vulnerable
    def initialize color, current_position, board
      super(color, current_position, board)
      @name = :pawn
      @direction = (color == :white) ? 1 : -1
      @first_move = true
      @enpassant_vulnerable = false
    end

    def move!
      super
      basic_move do
        if enpassant_vulnerable_move?
          @enpassant_vulnerable = true
          board.rememberable.memoize(:enpassant_pawn, color: self.color, passed_square: [px+direction, py], current_square: destination_position)
        else
          @enpassant_vulnerable = false  
        end

        if enpassant_capture?
          board.captured_pieces << enpassant_enemy
          destroy_enemy!
        end

        @first_move = false 
      end
      promote! if final_row?
    end

    private
      include Actionable::Stepable
      include Enpassant
      include Promotion
      def assign_symbol
        color == :white ? "♙" : "♟"
      end
  end
end

