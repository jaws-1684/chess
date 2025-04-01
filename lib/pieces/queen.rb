class Queen < Piece
  attr_reader :name

  def initialize(color)
    super(color)
    @name = 'queen'
  end

  include Slide

  def move(move)
    execute_move(move)
  end

  def valid_move?(move)
    return false unless diagonal_path?(move) || vertical_slide?(move) || horizontal_slide?(move)
    true
  end  

  private
  
  def assign_symbol
    color == :white ? "♕" : "♛"
  end

  def execute_move(move)
    if valid_move?(move) && clear_destination?(move)
      move.board.update_board(move)
      return true
    elsif valid_capture_target?(move)
      handle_capture(move)
      move.board.update_board(move)
      return true
    end
    false
  end
  
end
