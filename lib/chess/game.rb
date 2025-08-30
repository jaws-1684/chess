require_relative "piece"
require_relative "pieces/bishop"
require_relative "pieces/king"
require_relative "pieces/knight"
require_relative "pieces/pawn"
require_relative "pieces/queen"
require_relative "pieces/rook"
require_relative "board"
require_relative "displayable"
require_relative "computer/computer"
require_relative "algebraic_notation"
require "pry-byebug"


module Chess
	class Game
    using AlgebraicRefinements
  	attr_reader :board, :current_player
    
    def initialize player1, player2, chess_board=Board.new
      @board = chess_board
      @player_1 = player1
      @player_2 = player2
      @current_player = player1

      board.current_player_color = @current_player.color
    end

    def play
    	loop do
        begin
          game_messages.each { |m| puts m }

          if board.in_checkmate?
            puts "Checkmate #{current_player.name}-#{current_player.color} lost!"
            break
          end
          if board.in_stalemate?
            puts "Stalemate"
            break
          end
          Displayable.render(board.grid)

         
         
          if current_player.is_a?(Computer)
            current_player.set_board = @board
            board.computer = true
            current_player.select_piece!
            piece = current_player.selected_piece
            position = current_player.selected_position
            puts "#{piece.name} position #{position}"
          else
            board.computer = false 
            square = get_player_input("Select a piece:\s")
            piece = board.get_piece(square)
            position = get_player_input("Select a position to move:\s")
          end

      		piece.destination_position = position
      		piece.move!
          puts announce_move_message(piece)

          handle_turn
        rescue => e
          puts e.message  
        end  
   		end
    rescue Interrupt
      puts "byebye"
    end

    private
      def handle_turn
        @current_player = @current_player == @player_1 ? @player_2 : @player_1
        board.current_player_color = current_player.color
      end
      def game_messages
        mes = ["#{current_player.name}'s turn [#{current_player.color}]".colorize(:blue),
          "Captured pieces: #{board.captured_pieces.map(&:symbol)}".colorize(:blue)
         ] 
        mes << "#{current_player.color.capitalize} king in check!".colorize(:red) if board.in_check?
        mes 
      end
      def announce_move_message piece
         "#{piece.color.to_s.capitalize} #{piece.name} moved from #{piece.last_position.to_algebraic} " \
         "to #{piece.current_position.to_algebraic}."
      end
      def get_player_input prompt
        loop do
          print prompt.colorize(:green)
          input = gets.chomp.downcase

          if input == "save"
            puts "Enter filename (or press Enter for default 'saved_game.dat'):"
            filename = gets.chomp
            filename = 'chess.dat' if filename.empty?
            
            #add save_game functioanlity
            # save_game(filename)
            next  # Ask for input again after saving
          elsif input == "exit"
            puts "byebye".colorize(:red)
            exit
          end
          return input.split("").convert_to_index
        end
      end

  end
end