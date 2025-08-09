module Chess
  class Board
    attr_accessor :grid, :captured_pieces, :clone_pawn
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
    def update! last_position, destination_position
      piece = select_piece(last_position)
      handle_capture(destination_position) if !clear_destination?(destination_position)

      add_to_cell(destination_position, piece)
      clear_cell(last_position)
      @moves << destination_position

      #removing the cloned pawn created after a double step from the board if not attacked
      if !!clone_pawn&.enemy?(piece) && (destination_position != clone_pawn.current_position)
        clear_cell(clone_pawn.current_position)
        @clone_pawn = nil
      end
    end
    
    def select_piece position
      px, py = position
      raise "Invalid position: #{position}" unless valid_position?(position)
      @grid[px][py]
    end
    def is_a_piece? position, kind=Piece
       px, py = position
       @grid[px][py].is_a? kind
    end
    def clear_destination? position
      px, py = position
      @grid[px][py] == nil
    end
    def handle_capture position
      @captured_pieces << select_piece(position)
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

    private

    def populate_board
      @grid = Array.new(8) { Array.new(8) }

      @grid[0] = [
        Rook.new(:white, [0, 0]),
        Knight.new(:white, [0, 1]),
        Bishop.new(:white, [0, 2]),
        Queen.new(:white,  [0, 3]),
        King.new(:white,   [0, 4]),
        Bishop.new(:white, [0, 5]),
        Knight.new(:white, [0, 6]),
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
    def handle_enpassant
    end
  end
end