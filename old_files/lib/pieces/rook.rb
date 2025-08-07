class Rook < Piece
  attr_reader :name
  attr_accessor :has_moved 

  def initialize(color)
    super(color)
    @name = 'rook'
    @has_moved = false
  end

  include Slide
  
  def move(move)
    if valid_move?(move)
      move.board.update_board(move)
      @has_moved = true
      return true
    elsif valid_capture_target?(move) && clear_destination?(move)
      handle_capture(move)
      move.board.update_board(move)
      @has_moved = true
      return true
    end
    false
  end

  def valid_move?(move)
  return false unless vertical_slide?(move) || horizontal_slide?(move)
  
  return clear_destination?(move) unless valid_capture_target?(move)

  true
end


  private
  
  def assign_symbol
    color == :white ? "♖" : "♜"
  end
end