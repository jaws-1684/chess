class Knight < Piece
  attr_reader :name

  def initialize(color)
    super(color)
    @name = 'knight'
  end

  def move(move)
    execute_move(move)
  end

  def valid_move?(move)
    moves = possible_moves(move)
    return false unless moves.include? move.end_pos
    true
  end

  private
  
  def assign_symbol
    color == :white ? "♘" : "♞"
  end

  def possible_moves(move)
    x, y = move.start_pos
    moves = [
      [x+2, y+1], [x+2, y-1], [x-2, y+1], [x-2, y-1],
      [x+1, y+2], [x+1, y-2], [x-1, y+2], [x-1, y-2]
    ].select { |nx, ny| nx.between?(0, 7) && ny.between?(0, 7) }
   moves
  end

  def execute_move(move)
    if valid_move?(move) && clear_destination?(move)
      move.board.update_board(move)
      return true
    elsif valid_capture_target?(move)
      handle_capture(move)
      move.board.update_board(move)
      return true
    end
    false
  end
end