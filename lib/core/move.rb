module ChessCore
  class Move
    attr_reader :start_pos, :end_pos, :board

    def initialize(start_pos, end_pos, board)
      @start_pos = start_pos
      @end_pos = end_pos
      @board = board
    end

    def dx
      end_pos[0] - start_pos[0]
    end

    def cloned_board
      new_board = Marshal.load(Marshal.dump(board))

      return new_board
    end

    def dy
      end_pos[1] - start_pos[1]
    end

    def direction
      [dx <=> 0, dy <=> 0]
    end
  end
end