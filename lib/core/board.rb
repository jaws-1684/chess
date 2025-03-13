class Board
  attr_accessor :grid, :captured_pieces

  def initialize
    @grid = Array.new(8) { Array.new(8) }
    @captured_pieces = []
    populate_board
  end

  def valid_position?(pos)
    pos[0].between?(0,7) && pos[1].between?(0,7)
  end

  def select_piece(pos)
    raise "Invalid position: #{pos}" unless pos.is_a?(Array) && pos.size == 2
    x, y = pos
    raise "Invalid position: #{pos}" unless valid_position?(pos)
    grid[x][y]
  end

  def update_piece(pos, piece)
    row, col = pos
    return unless valid_position?(pos) 
    
    @grid[row][col] = piece
  end

  def update_board(move)
    piece = select_piece(move.start_pos)
    @grid[move.end_pos[0]][move.end_pos[1]] = piece
    @grid[move.start_pos[0]][move.start_pos[1]] = nil
  end

  def find_king(color)
    grid.each_with_index do |row, x|
      row.each_with_index do |piece, y|
        return [x, y] if piece.is_a?(King) && piece.color == color
      end
    end
    nil
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
