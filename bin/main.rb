 def handle_capture(move)
    captured_piece = move.board.select_piece(move.end_pos)
    move.board.captured_pieces << captured_piece if captured_piece
  end

  def clear_destination?(move)
    move.board.select_piece(move.end_pos).nil?
  end

  def valid_capture_target?(move)
    target_piece = move.board.select_piece(move.end_pos)
    target_piece&.color != color && !target_piece.nil?
  end