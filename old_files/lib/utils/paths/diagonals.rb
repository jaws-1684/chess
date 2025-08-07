module MoveDiagonally
  def diagonal_path?(move)
    return false unless valid_diagonal?(move)
    
    start_x, start_y = move.start_pos
    end_x, end_y = move.end_pos
    
    x_step = end_x > start_x ? 1 : -1
    y_step = end_y > start_y ? 1 : -1
    
    current_x = start_x + x_step
    current_y = start_y + y_step
    
    loop do
    	break if current_x == end_x
    	return false unless move.board.grid[current_x][current_y].nil?
      
      current_x += x_step
      current_y += y_step
    end
    
    true
  end

  private

  def valid_diagonal?(move)
    start_x, start_y = move.start_pos
    end_x, end_y = move.end_pos
    
    (end_x - start_x).abs == (end_y - start_y).abs
  end
end