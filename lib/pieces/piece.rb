class Piece
  attr_reader :color, :symbol

  def initialize(color)
    @color = color
    @symbol = assign_symbol
  end

  private

  def assign_symbol
    # To be overridden by subclasses
    "?"
  end
end