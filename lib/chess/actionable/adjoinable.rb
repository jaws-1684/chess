module Chess
  module Actionable
    module Adjoinable
      def possible_moves
        [
          [px + 1, py], [px + 1, py + 1], [px, py + 1], [px - 1, py + 1],
          [px - 1, py], [px - 1, py - 1], [px, py - 1], [px + 1, py - 1],
          [px, py + 2], [px, py - 2]
        ]
      end

      def valid_moves
        super do |pmove|
          case pmove
          when kingside_castle then valid_castle?(:kingside)
          when queenside_castle then valid_castle?(:queenside)
          else true
          end
        end
      end
    end
  end
end
