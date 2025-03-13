class Pawn < Piece
  attr_reader :first_move, :enpassant_vulnerable, :name

  def initialize(color)
    super(color)
    @first_move = true
    @name = 'pawn'
    @enpassant_vulnerable = false
  end

   def valid_move?(move)
    return false unless valid_step_pattern?(move)
    return false unless clear_destination?(move)
    return false unless vertical_path_clear?(move)

    true
  end

  include Stepping

  def move(move)
    return false unless valid_move?(move) || valid_diagonal_capture?(move) || valid_enpassant?(move)
    
    execute_move(move)
    true
  end

  private

  def assign_symbol
    color == :white ? "♙" : "♟"
  end

  def execute_move(move)
    if valid_enpassant?(move)
      perform_enpassant(move)
    else
      handle_capture(move) if valid_diagonal_capture?(move)
    end
    
    move.board.update_board(move)
    update_enpassant_status(move)
    @first_move = false
  end

  def valid_step_pattern?(move)
    single_step = step_forward?(move, 1)
    double_step = step_forward?(move, 2)
    single_step || (double_step && @first_move)
  end

  def vertical_path_clear?(move)
    vertical_path?(move)
  end

  def valid_diagonal_capture?(move)
    valid_diagonal_step?(move) && valid_capture_target?(move)
  end

  def valid_diagonal_step?(move)
    allowed_dx = color == :white ? 1 : -1
    move.dy.abs == 1 && move.dx == allowed_dx
  end

  
  def valid_enpassant?(move)
    return false unless valid_enpassant_move?(move)
    
    vulnerable_pos = enpassant_target_position(move)
    return false unless move.board.valid_position?(vulnerable_pos) # Add position check
    
    vulnerable_pawn = move.board.select_piece(vulnerable_pos)
    return false unless vulnerable_pawn.is_a?(Pawn)
    
    vulnerable_pawn.enpassant_vulnerable && 
    vulnerable_pawn.color != color
  end

  def valid_enpassant_move?(move)
    # Check if move is diagonal to empty square
    return false unless valid_diagonal_step?(move)
    return false unless move.board.select_piece(move.end_pos).nil?
    
    # Check valid en passant rank
    case color
    when :white
      move.start_pos[0] == 4 && move.end_pos[0] == 5
    when :black
      move.start_pos[0] == 3 && move.end_pos[0] == 2
    end
  end

  def enpassant_target_position(move)
    case color
    when :white
      [move.end_pos[0] - 1, move.end_pos[1]]
    when :black
      [move.end_pos[0] + 1, move.end_pos[1]]
    end
  end

  def update_enpassant_status(move)
    if first_move && (move.start_pos[0] - move.end_pos[0]).abs == 2
      @enpassant_vulnerable = true
    else
      @enpassant_vulnerable = false
    end
  end

  def perform_enpassant(move)
    # Capture the pawn in the adjacent position
    capture_pos = enpassant_target_position(move)
    captured_pawn = move.board.select_piece(capture_pos)
    
    move.board.captured_pieces << captured_pawn
    move.board.update_piece(capture_pos, nil)
  end
end