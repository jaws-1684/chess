class Pawn < Piece
  include Stepping

  def initialize
    super
    @first_move =  true
  end

  def move(spos, tpos, board)
    return true if step_forward(spos, tpos, board)

    if @first_move
      double_step_forward(spos, tpos, board)
      
      @first_move = false
      return true
    end

    nil
  end

  private
  
  def assign_symbol
    color == :white ? "♙" : "♟"
  end

  def double_step_forward(spos, tpos, board)
    step_forward(spos, tpos, board, 2)
  end
end