class Rook < Piece
  attr_reader :name

  def initialize(color)
    super(color)
    @name = 'rook'
  end

  include Slide
  
  def move(move)
    if valid_move(move)
      move.board.update_board(move)
      return true
    elsif valid_capture_target?(move) && clear_destination?(move)
      handle_capture(move)
      move.board.update_board(move)
      return true
    end
    false
  end

  def valid_move?(move)
    return false unless (vertical_slide?(move) || horizontal_slide?(move)) && clear_destination?(move)
    true
  end  

  private
  
  def assign_symbol
    color == :white ? "♖" : "♜"
  end
end