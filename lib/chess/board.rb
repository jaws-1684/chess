module Chess
  class Board
    attr_accessor :grid, :captured_pieces, :temporary_pawn
    attr_reader :moves, :last_move

    def initialize
      @grid = Array.new(8) { Array.new(8) }
      @captured_pieces = []
      @moves = []
      populate_board
    end
    def valid_position? position
      position[0].between?(0,7) && position[1].between?(0,7)
    end
    def update! piece, last_position, destination_position
      add_to_cell(destination_position, piece)
      clear_cell(last_position)
      @moves << destination_position

      #removing the cloned pawn created after a double step from the board if not attacked
      if !!temporary_pawn&.enemy?(piece) && (destination_position != temporary_pawn.current_position)
        clear_cell(temporary_pawn.current_position)
        @temporary_pawn = nil
      end
    end
    def select_piece  position, color
      with_unpack(position) do |x, y|
        raise "Invalid position: #{position}" unless valid_position?(position)
        raise "Invalid selection: #{position}. You cannot select an empty square!" if clear_destination?(position)
        piece = @grid[x][y] 
        raise "You can select only #{color} pieces!" unless piece.color == color 
        piece
      end
    end
    def is_a_piece? position, kind=Piece
      with_unpack(position) { |x, y|  @grid[x][y].is_a? kind }
    end
    def clear_destination? position
      with_unpack(position) { |x, y|  @grid[x][y] == nil }
    end
   
    def to_marshal
      {
        grid: @grid,
        captured_pieces: @captured_pieces
      }
    end

    def self.from_marshal data
      @grid = data[:grid]
      @captured_pieces = data[:captured_pieces]
    end
    def clear_cell position
      @grid[position[0]][position[1]] = nil
    end
    def add_to_cell position, piece
      @grid[position[0]][position[1]] = piece
    end
    def [] x, y
      @grid[x][y]
    end

    private

    def populate_board
      @grid = Array.new(8) { Array.new(8) }

      @grid[0] = [
        Rook.new(:white, [0, 0]),
        Knight.new(:white, [0, 1]),
        Bishop.new(:white, [0, 2]),
        Queen.new(:white,  [0, 3]),
        King.new(:white,   [0, 4]),
        nil, nil,
        # Bishop.new(:white, [0, 5]),
        # Knight.new(:white, [0, 6]),
        Rook.new(:white,   [0, 7])
      ]
      @grid[3] = Array.new(8) { |i| Pawn.new(:white, [3, i]) }

      @grid[7] = [
        Rook.new(:black,   [7, 0]),
        Knight.new(:black, [7, 1]),
        Bishop.new(:black, [7, 2]),
        Queen.new(:black,  [7, 3]),
        King.new(:black,   [7, 4]),
        Bishop.new(:black, [7, 5]),
        Knight.new(:black, [7, 6]),
        Rook.new(:black,   [7, 7])
      ]
      @grid[6] = Array.new(8) { |i| Pawn.new(:black, [6, i]) }

    end
    def with_unpack position
      px, py = position
      yield(px, py) if block_given?
    end
  end
end