require_relative "../lib/core/board"
require_relative "../lib/core/display"
require_relative "../lib/pieces/piece"
require_relative '../lib/pieces/rook'
require_relative '../lib/pieces/knight'
require_relative '../lib/pieces/bishop'
require_relative '../lib/pieces/queen'
require_relative '../lib/pieces/king'
require_relative '../lib/pieces/pawn'

board = Board.new
display = Display.new(board)
display.render