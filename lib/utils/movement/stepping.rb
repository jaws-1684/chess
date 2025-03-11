module Stepping
	def step_forward(spos, tpos, board)
    source_x, source_y = spos
    target_x, target_y = tpos
    piece = board[source_x][source_y]
    
    direction = piece.color == :white ? 1 : -1
    expected_target = [source_x + direction, source_y]
    
    if expected_target == tpos
      board[target_x][target_y] = piece
      board[source_x][source_y] = nil
      
      return true
    end
    
    nil
  end
end