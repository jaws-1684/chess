class King < Piece
  attr_reader :name
  attr_accessor :king_in_check

  def initialize(color)
    super(color)
    @name = 'king'
  end

  include Slide

  def move(move)
    execute_move(move)
  end

  def valid_move?(move)
    moves = possible_moves(move)
    return false unless moves.include? move.end_pos
    return false unless diagonal_path?(move) || vertical_slide?(move) || horizontal_slide?(move)
    true
  end

  def self.in_check?(board, color)
    king_pos = board.find_king(color)
    return false unless king_pos

    opponent_color = color == :white ? :black : :white

    board.grid.each_with_index do |row, x|
      row.each_with_index do |piece, y|
        next if piece.nil? || piece.color != opponent_color

        # Create a move from opponent's piece to king's position
        move = ChessCore::Move.new([x, y], king_pos, board)
        
        # Check if this is a valid capture move
        if piece.valid_capture_target?(move) && piece.valid_move?(move)
          return true
        end
      end
    end
    
    false
  end

#   def self.checkmate?(color)
#     return false unless in_check?(color)

#     king = board.find_king(color)
#     attackers = find_attackers(king, color)

#   # If multiple attackers, king must move (no blocking/capturing possible)
#     return false if king_can_escape?(king, color)

#   # For single attacker
#     if attackers.size == 1
#       attacker = attackers.first
#       return false if can_capture_attacker?(attacker, color) || 
#                     can_block_attack?(attacker, king, color)
#     end

#     true
#   end

#   def find_attackers(king, color)
#   opponent_color = (color == :white) ? :black : :white
#   board.grid.pieces.flatten.select do |piece|
#     piece.color == opponent_color && piece.attacks?(king.position, board)
#   end
#   end

#   def king_can_escape?(king, color)
#   king.possible_moves.any? do |move|
#     !square_under_attack?(move, color)
#   end
# end

#   def square_under_attack?(pos, defender_color)
#   attacker_color = (defender_color == :white) ? :black : :white
#   board.pieces.any? do |piece|
#     piece.color == attacker_color && piece.attacks?(pos, board)
#   end
#   end

#   def can_capture_attacker?(attacker, defender_color)
#   defender_pieces = board.pieces.select { |p| p.color == defender_color }
#   defender_pieces.any? do |piece|
#     piece != find_king(defender_color) && 
#     piece.valid_moves.include?(attacker.position)
#   end
#   end

#   def can_block_attack?(attacker, king, color)
#   return false unless attacker.is_a?(SteppingPiece) # Only for sliding pieces (Bishop/Rook/Queen)

#   path = get_attack_path(attacker.position, king.position)
#   path.any? do |block_square|
#     board.pieces.any? do |piece|
#       piece.color == color && 
#       piece != king && 
#       piece.valid_moves.include?(block_square)
#     end
#   end
#   end

# def get_attack_path(from, to)
#   # Generate squares between attacker and king (exclusive)
#   # Example: For rook moving vertically
#   if from[0] == to[0] # Same row
#     min, max = [from[1], to[1]].sort
#     (min + 1...max).map { |y| [from[0], y] }
#   elsif from[1] == to[1] # Same column
#     min, max = [from[0], to[0]].sort
#     (min + 1...max).map { |x| [x, from[1]] }
#   else # Diagonal
#     x_step = (to[0] - from[0]) > 0 ? 1 : -1
#     y_step = (to[1] - from[1]) > 0 ? 1 : -1
#     path = []
#     current = from.dup
#     while current != to
#       current = [current[0] + x_step, current[1] + y_step]
#       break if current == to
#       path << current
#     end
#     path
#   end
#   end


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


 