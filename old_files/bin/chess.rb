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





  
  
  end
  
  
