module FindKing
	def find_king_position(board, color)
    board.grid.each_with_index do |row, x|
      row.each_with_index do |piece, y|
        return [x, y] if piece.is_a?(King) && piece.color == color
      end
    end
    nil
  end
end
