module Chess
  module Actionable
    module Stepable
      PAWN_MOVES = %i[step double_step attack_left attack_right].freeze

      def possible_moves
        [
          [px + direction, py],
          [px + (2 * direction), py],
          [px + direction, py - direction],
          [px + direction, py + direction]
        ]
      end

      PAWN_MOVES.each_with_index do |m, idx|
        define_method(m) { possible_moves[idx] }
      end

      def enpassant
        board.rememberable.dig(:enpassant_pawn, :passed_square)
      end

      def valid_moves
        super do |pmove|
          case pmove
          # selection the the results of the superclass only the spefic valid pawn moves
          # also its ensuring no friendly attack or out_of_bounds board positions can be valid
          when step then !board.is_a_piece?(pmove)
          when double_step then first_move? && !board.is_a_piece?(pmove)
          when enpassant then valid_enpassant_attack?
            # no need to check for specific attacks cause at this point only attack will remain valid if any valid move exists
          else piece(pmove)&.enemy?(self)
          end
        end
      end
    end
  end
end