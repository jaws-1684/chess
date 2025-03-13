require_relative '../paths/verticals'

module Stepping
  include MoveVertical
  def step_forward?(move, steps)
    start_x, start_y = move.start_pos
    direction = move.board.select_piece(move.start_pos).color == :white ? steps : -steps
    expected_target = [start_x + direction, start_y]
    expected_target == move.end_pos
  end
end