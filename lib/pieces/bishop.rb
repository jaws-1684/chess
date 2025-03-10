class Bishop < Piece
  private
  
  def assign_symbol
    color == :white ? "♗" : "♝"
  end
end