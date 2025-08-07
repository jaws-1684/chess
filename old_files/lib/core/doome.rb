require_relative 'move'

module Doomed
  include ChessCore

  def in_check?(board, current_player_color, king_pos)
    return false unless king_pos

    opponent_color = current_player_color == :white ? :black : :white

    attack_status?(board, opponent_color, king_pos)
  end

  def in_check_mate?(board, current_player_color, king_pos)
  return false unless in_check?(board, current_player_color, king_pos)
  
  !move_status?(board, current_player_color, king_pos) &&
  !safe_attack_checking_piece?(board, current_player_color, king_pos) &&
  !safe_blocking_path_between?(board, current_player_color, king_pos) # Added parameters
end

  private

  def attack_status?(board, opponent_color, king_pos)
  board.grid.each_with_index do |row, x|
    row.each_with_index do |piece, y|
      next if piece.nil? || piece.color != opponent_color

      move = ChessCore::Move.new([x, y], king_pos, board)
      return true if piece.valid_move?(move) 
    end
  end
  false
end
  
  def move_status?(board, current_player_color, king_pos)
    king = board.grid[king_pos[0]][king_pos[1]]
    possible_moves = [
      [king_pos[0] + 1, king_pos[1]], [king_pos[0] + 1, king_pos[1] + 1],
      [king_pos[0], king_pos[1] + 1], [king_pos[0] - 1, king_pos[1] + 1],
      [king_pos[0] - 1, king_pos[1]], [king_pos[0] - 1, king_pos[1] - 1],
      [king_pos[0], king_pos[1] - 1], [king_pos[0] + 1, king_pos[1] - 1]
    ].select { |x, y| x.between?(0, 7) && y.between?(0, 7) }

    possible_moves.any? do |end_pos|
      target_piece = board.grid[end_pos[0]][end_pos[1]]
      next if target_piece && target_piece.color == current_player_color

      temp_board = Marshal.load(Marshal.dump(board))
      temp_board.grid[end_pos[0]][end_pos[1]] = temp_board.grid[king_pos[0]][king_pos[1]]
      temp_board.grid[king_pos[0]][king_pos[1]] = nil
      !in_check?(temp_board, current_player_color, end_pos)
    end
  end

  # Checks if the king can escape from the attacking piece by moving
  def safe_attack_checking_piece?(board, current_player_color, king_pos)
    opponent_color = current_player_color == :white ? :black : :white
    checking_piece = find_checking_piece(board, opponent_color, king_pos)
    return false unless checking_piece

    board.grid.each_with_index do |row, x|
      row.each_with_index do |piece, y|
        next if piece.nil? || piece.color == opponent_color

        temp_board = Marshal.load(Marshal.dump(board))
        move = ChessCore::Move.new([x, y], checking_piece, temp_board)

        if piece.valid_move?(move) && piece.valid_capture_target?(move)
          piece.move(move)
          return true if !in_check?(temp_board, current_player_color, king_pos)
        end
      end
    end

    false
  end

  # Checks if the king's path can be blocked by any of its pieces
  def safe_blocking_path_between?(board, current_player_color, king_pos)
    opponent_color = current_player_color == :white ? :black : :white
    checking_piece = find_checking_piece(board, opponent_color, king_pos)
    return false unless checking_piece

    path = get_path_between(king_pos, checking_piece)
    return false if path.empty?

    board.grid.each_with_index do |row, x|
      row.each_with_index do |piece, y|
        next if piece.nil? || piece.color != current_player_color

        path.each do |block_pos|
          temp_board = Marshal.load(Marshal.dump(board))
          temp_piece = temp_board.grid[x][y]
          move = ChessCore::Move.new([x, y], block_pos, temp_board)

          next unless temp_piece.valid_move?(move) || temp_piece.valid_capture_target?(move)

          return true unless in_check?(temp_board, current_player_color, king_pos)
        end
      end
    end

    false
  end

  # Returns the path between the king and the attacking piece
  def get_path_between(king_pos, attacker_pos)
  k_row, k_col = king_pos
  a_row, a_col = attacker_pos

  if k_row == a_row # Horizontal
    range = [k_col, a_col].min+1 .. [k_col, a_col].max-1
    range.map { |col| [k_row, col] }
  elsif k_col == a_col # Vertical
    range = [k_row, a_row].min+1 .. [k_row, a_row].max-1
    range.map { |row| [row, k_col] }
  elsif (a_row - k_row).abs == (a_col - k_col).abs # Diagonal
    row_step = a_row > k_row ? 1 : -1
    col_step = a_col > k_col ? 1 : -1
    positions = []
    current_row = k_row + row_step
    current_col = k_col + col_step
    while current_row != a_row
      positions << [current_row, current_col]
      current_row += row_step
      current_col += col_step
    end
    positions
  else # Knight or adjacent
    []
  end
end

  # Finds the piece that is checking the king
  def find_checking_piece(board, opponent_color, king_pos)
    board.grid.each_with_index do |row, x|
      row.each_with_index do |piece, y|
        next if piece.nil? || piece.color != opponent_color

        move = ChessCore::Move.new([x, y], king_pos, board)
        return [x, y] if piece.valid_move?(move) && piece.valid_capture_target?(move)
      end
    end
    nil
  end
end
