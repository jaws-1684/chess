module Chess
  module Actionable
    module Slidable
      # theese methods are aliesed in the pieces classes so they can be used be the queen too
      module Straight
        def straight_moves
          (0..7).each_with_object([]) do |i, a|
            a << [px, i] unless i == py
            a << [i, py] unless i == px
          end.uniq
        end
      end
    end
  end
end
