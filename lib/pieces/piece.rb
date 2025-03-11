class Piece
  attr_reader :color, :symbol

  def initialize(color)
    @color = color
    @symbol = assign_symbol
  end

  def move(spos, tpos, board)
    raise NotImplementedError, "Subclasses must implement the move method"
  end

  private

  def assign_symbol
    raise NotImplementedError, "Subclasses must implement the assign_symbol method"
  end
  
end