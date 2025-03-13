require_relative "../lib/core/board"
require_relative "../lib/core/display"
require_relative "../lib/core/move"
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
    puts "Welcome to chess. Press Ctrl+C to exit"
    begin
      game_loop
    rescue Interrupt
      puts "\nExit"
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
  
  def game_loop
    # welcome_screen
    loop do
      begin
        handle_turn
        check = King.in_check?(board, current_player)
        puts "xoxoxo you are in check bitch" if check
        
      rescue StandardError => e
        puts "Error: #{e.message}"
        retry
      end
    end
  end
  
  def handle_turn
    render_game_state
    start_pos = get_player_input("#{current_player}'s turn. Select a piece (e.g., 'e2'):")
    end_pos = get_player_input("#{current_player}'s turn. Enter your move (e.g., 'e4'):")
    
    if execute_move(start_pos, end_pos)
      switch_turns
    end
  end
  
  def render_game_state
    # clear_screen
    display.render
  end
  
  def get_player_input(prompt)
    loop do
      puts prompt
      input = gets.chomp
      position = convert_to_index(input)
      
      return position if valid_position?(position)
      
      puts "Invalid input! Please enter a position in the format 'a1' to 'h8'."
    end
  end
  
  def valid_position?(position)
    position && position.all? { |coordinate| coordinate.between?(0, 7) }
  end
  
  def convert_to_index(algebraic_notation)
    return nil unless algebraic_notation.length == 2
    
    col, row = algebraic_notation[0], algebraic_notation[1]
    col_index = ('a'..'h').to_a.index(col.downcase)
    row_index = row.to_i - 1
    
    return nil unless col_index && row_index.between?(0, 7)
    
    [row_index, col_index]
  end
  
  def to_algebraic_notation(position)
    row, col = position
    letter = ('a'..'h').to_a[col]
    number = row + 1
    
    "#{letter}#{number}"
  end
  
  def announce_move(move, piece)
    puts "#{piece.color.to_s.capitalize} #{piece.name} moved from #{to_algebraic_notation(move.start_pos)} " \
         "to #{to_algebraic_notation(move.end_pos)}."
    puts "Captured pieces: #{board.captured_pieces.map(&:symbol).join(', ')}" unless board.captured_pieces.empty?
  end
  
  def report_error(message)
    puts "Error: #{message}"
    false
  end
  
  def switch_turns
    @current_player = @current_player == :white ? :black : :white
  end
  
  def clear_screen
    system("clear") || system("cls")
  end

  def welcome_screen
    clear_screen

    puts <<~HEREDOC
      \e[1;36m
      \t\t  \e[1;32m# \e[1;33mWELCOME TO THE GAME \e[1;32m#\e[0m


      \t  \e[1;36m ██████╗██╗  ██╗███████╗███████╗ ███████╗\e[0m
      \t  \e[1;36m██╔════╝██║  ██║██╔════╝██╔════╝ ██╔════╝\e[0m
      \t  \e[1;36m██║     ███████║█████╗  ███████╗ ███████╗\e[0m
      \t  \e[1;36m██║     ██╔══██║██╔══╝  ╚════██║ ╚════██║\e[0m
      \t  \e[1;36m╚██████╗██║  ██║███████╗███████║ ███████║\e[0m
      \t  \e[1;36m ╚═════╝╚═╝  ╚═╝╚══════╝╚══════╝ ╚══════╝\e[0m

      \t  \e[1;33m===========================================\e[0m

      \t  \e[0;36m▶ \e[0;32mDeveloped by: \e[1;32mjaws\e[0m
      \t  \e[0;36m▶ \e[0;32mGitHub: \e[4;32mgithub.com/jaws-1684\e[0m
      \t  \e[0;36m▶ \e[0;32mVersion: \e[1;32m1.0.0\e[0m

    HEREDOC

    loading_sequence = [
      "Loading chess engine modules",
      "Initializing board configuration",
      "Chess online"
    ]

    loading_sequence.each do |message|
      print "\s\e[1;32m##{message}\e[0m"
      3.times do
        print "\e[1;31m.\e[0m"
        sleep(0.3)
      end
      puts
    end

    puts "\n\e[1;31m\sPress Enter to continue or Ctrl+C to abort\e[0m"
    gets
  end
end

if __FILE__ == $PROGRAM_NAME
  game = Game.new
  game.play
end



    

  