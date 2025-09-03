# frozen_string_literal: true

module Chess
  module AlgebraicRefinements
    refine Array do
      def convert_to_index
        return [] unless length

        col = self[0]
        row = self[1]
        col_index = ('a'..'h').to_a.index(col.downcase)
        row_index = row.to_i - 1
        raise "Invalid input! Please enter a position like 'e2' or 'h8'." unless col_index && row_index.between?(0, 7)

        [row_index, col_index]
      end

      def to_algebraic
        row, col = self
        letter = ('a'..'h').to_a[col]
        number = row + 1

        "#{letter}#{number}"
      end
    end
  end
end
