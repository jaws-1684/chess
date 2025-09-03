module Chess
  module Actionable
    module Enpassant
      def enpassant_vulnerable_move?
        first_move? && destination_position == double_step
      end

      def adjacent_pieces
        [piece([px, py + 1]), piece([px, py - 1])]
      end

      def valid_enpassant_attack?
        adjacent_pieces.any? { |piece| piece&.name == :pawn && piece&.enemy?(self) && piece.enpassant_vulnerable? }
      end

      def enpassant_capture?
        # checking the passed square
        # if there is no enpassant pawn this will return false
        destination_position == board.rememberable.dig(:enpassant_pawn, :passed_square)
      end

      def enpassant_enemy
        # getting the actual enemy piece to be captured
        position = board.rememberable.dig(:enpassant_pawn, :current_square)
        piece(position)
      end

      def destroy_enemy!
        board.clear_cell(enpassant_enemy.current_position)
      end
    end
  end
end
