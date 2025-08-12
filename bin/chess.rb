#!/usr/bin/env ruby
require_relative "../chess/piece"
require_relative "../chess/board"
require_relative "../chess/display"
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
  
  puts "Welcome to chess. Press Ctrl+C to exit"
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

  def save_game(filename = 'saved_game.dat')
  begin
    # Ensure directory exists
    dir = File.dirname(filename)
    Dir.mkdir(dir) unless File.exists?(dir) || dir == '.'
    
    File.open(filename, 'wb') do |file|
      # Marshal.dump the entire game state
      game_state = {
        board: @board,
        current_player: @current_player,
        timestamp: Time.now
      }
      file.write(Marshal.dump(game_state))
    end
    puts "Game saved successfully as #{filename}."
    true
  rescue StandardError => e
    puts "Error saving game: #{e.message}"
    puts e.backtrace.join("\n") if $DEBUG
    false
  end
end

def load_game(filename)
  begin
    return false unless File.exist?(filename)

    File.open(filename, 'rb') do |file|
      data = Marshal.load(file.read)
      
      # Make sure we have a valid board object
      if data[:board].is_a?(Board)
        @board = data[:board]
        @display = Display.new(@board) # Recreate display with loaded board
        @current_player = data[:current_player]
        
        puts "Game loaded successfully!"
        puts "It's #{@current_player}'s turn."
        
        # Optional: Display when the save was created
        if data[:timestamp]
          puts "This save was created on #{data[:timestamp].strftime('%Y-%m-%d at %H:%M')}"
        end
        return true
      else
        puts "Error: Save file contains invalid board data."
        return false
      end
    end
  rescue TypeError => e
    puts "Error loading game: The save file appears to be corrupted."
    puts "Technical details: #{e.message}" if $DEBUG
    false
  rescue StandardError => e
    puts "Error loading game: #{e.message}"
    puts e.backtrace.join("\n") if $DEBUG
    false
  end
  end

  def display_save_options
  puts "Options:"
  puts "  1. Start a new game"
  puts "  2. Load saved game"
  choice = gets.chomp

  if choice == '2'
    load_saved_game
  else
    puts "Starting a new game..."
  end
end

def load_saved_game
  save_files = Dir.glob('*.dat').select { |f| File.file?(f) }
  
  if save_files.empty?
    puts "No saved games found."
    return
  end
  
  puts "Available saved games:"
  save_files.each_with_index do |file, index|
    puts "  #{index + 1}. #{file} (#{File.mtime(file).strftime('%Y-%m-%d %H:%M')})"
  end
  
  puts "Enter the number of the game to load (or 0 to cancel):"
  choice = gets.chomp.to_i
  
  if choice.between?(1, save_files.size)
    load_game(save_files[choice - 1])
  else
    puts "Starting a new game..."
  end
end

def handle_exit
  puts "\nDo you want to save the game before exiting? (y/n)"
  answer = gets.chomp.downcase
  
  if answer == 'y'
    puts "Enter filename (or press Enter for default 'saved_game.dat'):"
    filename = gets.chomp
    filename = 'saved_game.dat' if filename.empty?
    
    if save_game(filename)
      puts "Game saved. Goodbye!"
    else
      puts "Save failed. Exiting without saving."
    end
  else
    puts "Exiting without saving. Goodbye!"
  end
end


def promote_pawn(pos)
  puts "Promote pawn to (Q/R/B/N):"
  choice = gets.chomp.upcase

  new_piece = case choice
              when 'Q' then Queen.new(@current_player)
              when 'R' then Rook.new(@current_player)
              when 'B' then Bishop.new(@current_player)
              when 'N' then Knight.new(@current_player)
              else Queen.new(@current_player) # Default to Queen
              end

  @board.grid[pos[0]][pos[1]] = new_piece
end


  include FindKing

  def game_state(board, current_player_color)

    king_pos = find_king_position(board, current_player_color)
    return unless king_pos
    king_piece = @board.select_piece(king_pos)

    # if king_piece.check_state(board, current_player_color, king_pos)
    #   puts 'in check'
    # elsif king_piece.check_mate_state(board, current_player_color, king_pos)
    #   puts 'in check mate'
    # end

    puts "check state: #{king_piece.check_state(board, current_player_color, king_pos)}"
    puts "check mate state: #{king_piece.check_mate_state(board, current_player_color, king_pos)}"
  end

  def game_loop
    loop do
      begin
        game_state(board, current_player)
        handle_turn
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
    piece = board.select_piece(end_pos)

    if piece.is_a?(Pawn) && (end_pos[0] == 0 || end_pos[0] == 7)
      promote_pawn(end_pos)
    end

    switch_turns
  end
end

  
  def render_game_state
    display.render
  end
  
  def get_player_input(prompt)
  loop do
    puts prompt
    puts "(Type 'save' to save the game, 'exit' to quit)"
    input = gets.chomp.downcase

    if input == "save"
      puts "Enter filename (or press Enter for default 'saved_game.dat'):"
      filename = gets.chomp
      filename = 'saved_game.dat' if filename.empty?
      
      save_game(filename)
      next  # Ask for input again after saving
    elsif input == "exit"
      handle_exit
      exit
    end

    position = convert_to_index(input)
    return position if valid_position?(position)

    puts "Invalid input! Please enter a position like 'e2' or 'h8'."
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
    puts "\e[H\e[2J"
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



    
# require 'colorize' or https://github.com/ku1ik/rainbow(might be better)

size = 8

size.times do |i|
  size.times do |j|
    if (i + j).even?
      print " ♖ ♜ ".colorize(background: :black)
    else
      print " ♖ ♜ ".colorize(background: :white)
    end
  end
  puts
end

x = :♜ 