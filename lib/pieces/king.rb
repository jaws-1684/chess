require_relative '../core/doome'
require_relative '../core/beacon'

class King < Piece
  attr_reader :name
  attr_accessor :has_moved 

  def initialize(color)
    super(color)
    @name = 'king'
    @has_moved = false
  end

  include Slide
  include Doomed
  include FindKing

  def move(move)
    execute_move(move)
    @has_moved = true
  end

  def valid_move?(move)
    moves = possible_moves(move)
    return false unless moves.include? move.end_pos
    return false unless diagonal_path?(move) || vertical_slide?(move) || horizontal_slide?(move)
    true
  end

  def check_state(board, current_player_color, king_pos)
    return true if in_check?(board, current_player_color, king_pos)
  end

  def check_mate_state(board, current_player_color, king_pos)
    return true if in_check_mate?(board, current_player_color, king_pos)
  end
  private
  
  def assign_symbol
    color == :white ? "♔" : "♚"
  end

  def possible_moves(move)
    x, y = move.start_pos
    moves = [
      [x+1, y], [x+1, y+1], [x, y+1], [x-1, y+1],
      [x-1, y], [x-1, y-1], [x, y-1], [x+1, y-1]
    ].select { |nx, ny| nx.between?(0, 7) && ny.between?(0, 7) }
   moves
  end

  def execute_move(move)
    return false unless prevent_self_check(move, self.color)

    if valid_move?(move) && clear_destination?(move)
      move.board.update_board(move)
      return true
    elsif valid_capture_target?(move)
      handle_capture(move)
      move.board.update_board(move)
      return true
    elsif castle(move)
      return true  
    end
    false
  end

   def prevent_self_check(move, current_player_color)
    temp_board = move.cloned_board
    temp_board.update_board(move)

    if check_state(temp_board, current_player_color, move.end_pos)
      false
    else
      true
    end  
  end

def castle(move)
  king = move.board.select_piece(move.start_pos)
  return false unless king.is_a?(King) && !king.has_moved

  row = king.color == :white ? 0 : 7
  
  if move.end_pos == [row, 6] # Kingside castling
    rook_pos = [row, 7]
    rook = move.board.select_piece(rook_pos)
    return false unless rook.is_a?(Rook) && !rook.has_moved
    return false unless move.board.grid[row][5].nil? && move.board.grid[row][6].nil?
    return false if in_check?(move.board, king.color, [row, 4]) || 
                   in_check?(move.board, king.color, [row, 5]) || 
                   in_check?(move.board, king.color, [row, 6])

    # Update king and rook positions
    move.board.grid[row][4] = nil
    move.board.grid[row][6] = king
    move.board.grid[row][5] = rook
    move.board.grid[row][7] = nil
    
    # Update movement status
    king.has_moved = true
    rook.has_moved = true
    return true
  end

  if move.end_pos == [row, 2] # Queenside castling
    rook_pos = [row, 0]
    rook = move.board.select_piece(rook_pos)
    return false unless rook.is_a?(Rook) && !rook.has_moved
    return false unless move.board.grid[row][1].nil? && 
                        move.board.grid[row][2].nil? && 
                        move.board.grid[row][3].nil?
    return false if in_check?(move.board, king.color, [row, 4]) || 
                   in_check?(move.board, king.color, [row, 3]) || 
                   in_check?(move.board, king.color, [row, 2])

    # Update king and rook positions
    move.board.grid[row][4] = nil
    move.board.grid[row][2] = king
    move.board.grid[row][3] = rook
    move.board.grid[row][0] = nil
    
    # Update movement status
    king.has_moved = true
    rook.has_moved = true
    return true
  end

  false
end
end

