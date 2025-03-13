require_relative '../utils/movement/stepping'
require_relative '../utils/movement/sliding'

class Piece
  attr_reader :color, :symbol

  def initialize(color)
    @color = color
    @symbol = assign_symbol
  end

  def valid_capture_target?(move)
    target_piece = move.board.select_piece(move.end_pos)
    target_piece&.color != color && !target_piece.nil?
  end

  include ChessCore

  def move
    raise NotImplementedError, "Subclasses must implement the move method"
  end

  def valid_move?(move)
     raise NotImplementedError, "Subclasses must implement the valid_move? method"
  end


  private

  def assign_symbol
    raise NotImplementedError, "Subclasses must implement the assign_symbol method"
  end

 

  def handle_capture(move)
    captured_piece = move.board.select_piece(move.end_pos)
    move.board.captured_pieces << captured_piece if captured_piece
  end

  def clear_destination?(move)
    move.board.select_piece(move.end_pos).nil?
  end

end