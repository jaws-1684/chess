module Chess
  module Actionable
    module Lshapable
      def possible_moves
        x = [2, 1, -1, -2, -2, -1, 1, 2]
        y = [1, 2, 2, 1, -1, -2, -2, -1]
        (0..7).each_with_object([]) do |i, a|
          a << [px + x[i], py + y[i]]
        end.uniq
      end
    end
  end
end