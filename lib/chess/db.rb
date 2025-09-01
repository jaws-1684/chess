module Chess
	module Db
		module Save
			def save_file! filename
				filename = "chess_#{Time.now.strftime('%Y%m%d')}.dat" if filename.empty?
				begin
				# Ensure directory exists
					path_to_file =  File.expand_path("../../bin/#{filename}", File.dirname(__FILE__))
					File.open(path_to_file, 'wb') do |file|
						# Marshal.dump the entire game state
						game_state = {
						board: @board,
						current_player: @current_player,
						player_1: @player_1,
						player_2: @player_2,
						timestamp: Time.now
						}
						file.write(Marshal.dump(game_state))
					end
				puts "Game saved successfully as #{filename}."
				true
				rescue => e
					puts e.message
					puts "Error while saving game."
					false
				end
			end
		end

		module Load
			def load_file! filename
				return false unless File.exist?(filename)

				File.open(filename, 'rb') do |file|
				data = Marshal.load(file.read)

				if data[:board].is_a?(Board)
					self
					board = data[:board]
					player_1 = data[:player_1]
					player_2 = data[:player_2]
					current_player = data[:current_player]
					puts "Game loaded successfully!"
				end
				game = self.new(player_1, player_2, board)
				game.instance_variable_set(:@current_player, current_player)
				game		
				rescue
					puts "Error: no valid save files.".colorize(:red)
				end
			end

			def load_saved_game saved_files
				puts "Enter the number of the game to load (or 0 to cancel):"
				choice = gets.chomp.to_i

				if choice.between?(1, saved_files.size)
					self.load_file!(saved_files[choice - 1])
				else
					self.load_file!(saved_files[0])
				end
			end
		end
		def self.saved_files
				path = File.expand_path('../../bin/', File.dirname(__FILE__))
				Dir.glob("#{path}/*.dat").select { |f| File.file?(f) }
			end

		def self.saved_games?
			if saved_files.empty?
				puts "No saved games found." 
			else
				puts "Available saved games:"
				saved_files.each_with_index do |file, index|
					puts "  #{index + 1}. #{File.basename(file)} (#{File.mtime(file).strftime('%Y-%m-%d %H:%M')})"
				end	
			end
		end

	end
end