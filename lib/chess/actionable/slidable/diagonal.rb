module Chess
  module Actionable

    module Slidable
      # theese methods are aliesed in the pieces classes so they can be used be the queen too
      module Diagonal
        def diagonal_moves
          (0..7).each_with_object([]) do |i, a|
            a << [px + i, py + i]
            a << [px - i, py - i]
            a << [px + i, py - i]
            a << [px - i, py + i]
          end.uniq
        end
      end
    end
  end
end