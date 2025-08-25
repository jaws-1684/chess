module MoveHorizontal
  def horizontal_path?(move)
    start_x, start_y = move.start_pos
    end_x, end_y = move.end_pos
    
    return false unless start_x == end_x 
    
    check_range = if start_y < end_y
                    (start_y + 1)..(end_y - 1)
                  else
                    (end_y + 1)..(start_y - 1)
                  end
                  
    check_range.each do |y|
      return false unless move.board.grid[start_x][y].nil?
    end
    
    true
  end
end