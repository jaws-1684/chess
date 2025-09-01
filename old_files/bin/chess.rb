require_relative "../lib/core/board"
require_relative "../lib/core/display"
require_relative "../lib/core/move"
require_relative '../lib/core/doome'
require_relative '../lib/core/beacon'
require_relative "../lib/pieces/piece"
require_relative '../lib/pieces/rook'
require_relative '../lib/pieces/knight'
require_relative '../lib/pieces/bishop'
require_relative '../lib/pieces/queen'
require_relative '../lib/pieces/king'
require_relative '../lib/pieces/pawn'


class Game
  attr_reader :board, :display, :current_player
  
  def initialize
    @board = Board.new
    @display = Display.new(board)
    @current_player = :white
  end
  
  def play
  clear_screen
  welcome_screen
  

  display_save_options
  
  begin
    game_loop
  rescue Interrupt
    handle_exit
  end
  end

  def execute_move(start_pos, end_pos)
    move = ChessCore::Move.new(start_pos, end_pos, @board)
    piece = @board.select_piece(move.start_pos)

    return report_error("No piece at starting position!") unless piece
    return report_error("That's not your piece!") unless piece.color == @current_player
    
    if piece.move(move)
      announce_move(move, piece)
      return true
    else
      return report_error("Invalid move for #{piece.name}!")
    end
  end
  
  private

 






  
  
  end
  
  
