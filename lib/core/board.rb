class Board
  attr_reader :grid

  def initialize
    @grid = Array.new(8) { Array.new(8) }
    populate_board
  end

  private

  def populate_board
    @grid[0] = [
      Rook.new(:white), Knight.new(:white), Bishop.new(:white), Queen.new(:white),
      King.new(:white), Bishop.new(:white), Knight.new(:white), Rook.new(:white)
    ]
    @grid[1] = Array.new(8) { Pawn.new(:white) }

    @grid[7] = [
      Rook.new(:black), Knight.new(:black), Bishop.new(:black), Queen.new(:black),
      King.new(:black), Bishop.new(:black), Knight.new(:black), Rook.new(:black)
    ]
    @grid[6] = Array.new(8) { Pawn.new(:black) }

  end
end