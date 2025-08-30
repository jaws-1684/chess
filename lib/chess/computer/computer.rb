module Chess
	class Computer
		attr_reader :name, :color, :board, :selected_position, :selected_piece
		def initialize name="Matricz", color
			@name = name
			@color = color
			@selected_position = nil 
			@selected_piece = nil
			["moves_buffer","attacks_buffer","best_move_buffer", "best_attack_buffer"].each {|v| instance_variable_set("@#{v}", Hash.new) }
		end
		def set_board=(board)
			@board = board
		end
		def select_piece!
			search_piece!
			return attack(@best_attack_buffer) if @best_attack_buffer&.any?
			return move(@best_move_buffer) unless @best_move_buffer.values.flatten.empty?
			return move(@attacks_buffer) unless @attacks_buffer.values.flatten.empty?
			move(@moves_buffer)
		end
		private
			def search_piece!
				buffers = [@attacks_buffer, @moves_buffer, @best_move_buffer, @best_attack_buffer]
				buffers.each { |b| b.clear }

				board.players_pieces.each do |piece|
					piece_position = piece.current_position
					safe_moves = []
					best_moves = []
	
					piece.safe_moves do |board, position|
						next if board.in_check?  
						if !board.square_under_attack?(position) || sacrifice_worth?(piece, position)	
							safe_moves << position
						end

						board.players_pieces.reject { |p| p == piece }.each do |ally|
							best_moves << position unless board.square_under_attack?(ally.current_position)
						end	
					end
					next if safe_moves.empty?

					enemies = safe_moves.select { |pos| board.is_a_piece?(pos) }.map {|pos| board.select_square(pos) }.sort.reverse
					puts enemies.map(&:current_position)
				
					if enemies.any?
					#most valuebale enemy
						mvenemy_position = enemies.first.current_position
						if @best_attack_buffer.empty?
							@best_attack_buffer[piece_position] = mvenemy_position
						end
						other_enemy = board.select_square(@best_attack_buffer.values.first)
						if other_enemy && enemies.first > other_enemy 
							@best_attack_buffer.clear
							@best_attack_buffer[piece_position] = mvenemy_position
						end
					end
					enemies_pos = enemies.map(&:current_position)
					unless best_moves.compact.empty?
						best_moves = sort_moves(best_moves.compact)
					end
					safe_moves = sort_moves(safe_moves.compact)
				
					set_moves(piece_position, moves: safe_moves, enemies_pos: enemies_pos, best_moves: best_moves)
				end
				
				#sanitazing the output a bit
				buffers.each { |b| b.reject! {|_, v| v.empty? } }
			end

			def move dictionary
				# piece_position = dictionary.keys.sample
				sorted_hash = Hash[ dictionary.sort_by { |key, val| board.select_square(key) } ]
				piece_position = sorted_hash.keys[0]
				@selected_piece = board.select_square(piece_position)
				@selected_position = dictionary[piece_position][0]
			end
			def set_moves position, **args
				@moves_buffer[position] = args[:moves]
				@attacks_buffer[position] = args[:enemies_pos]
				@best_move_buffer[position] = args[:best_moves]
			end
			def attack dictionary
				@selected_piece = board.select_square(dictionary.keys[0])
				@selected_position = dictionary.values[0]
			end
			def sort_moves moves
				case board.current_player_color
					when :white 
						moves.sort_by {|x, y| x }.reverse!
					when :black
						moves.sort_by {|x, y| x }
				end		
			end
			def sacrifice_worth? piece, position
				enemy = board.select_square(position)
				return false unless enemy
				enemy > piece
			end

	end
end
