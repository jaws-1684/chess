class Knight < Piece
  private
  
  def assign_symbol
    color == :white ? "♘" : "♞"
  end
end