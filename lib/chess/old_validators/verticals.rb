module MoveVertical
  def vertical_path?(move)
    start_x, start_y = move.start_pos
    end_x, end_y = move.end_pos

    return false unless start_y == end_y

    check_range = if start_x < end_x
                    (start_x + 1)..(end_x - 1)
                  else
                    (end_x + 1)..(start_x - 1)
                  end

    check_range.each do |x|
      return false unless move.board.grid[x][start_y].nil?
    end

    true
  end
end