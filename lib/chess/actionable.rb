module Chess
	module Actionable
		module Stepable
			def double_step
				[px + (2 * direction), py]
			end
			def attack_right
				[px+direction, py+direction]
			end
			def attack_left
				[px+direction, py-direction]
			end
			def step
				[px + direction, py]
			end
			def valid_base_attack? square=destination_position
				return false unless board.valid_position?(square)
		  	return true if piece(square)&.enemy?(self) 
		  end

			def possible_moves
				@possible_moves = Array.new

				@possible_moves << step if board.clear_destination?(step)
				@possible_moves << double_step if first_move && board.clear_destination?(double_step)

				@possible_moves << attack_right if valid_base_attack?(attack_right)
				@possible_moves << attack_left if valid_base_attack?(attack_left)
				@possible_moves << board.rememberable.dig(:enpassant_pawn, :passed_square) if valid_enpassant_attack?
			
				@possible_moves
			end
		end

		module Slidable
			module Straight
				def straight_moves x=px, y=py
				  (0..7).each_with_object([]) do |i,a|
				    a << [x,i] unless i == y
				    a << [i,y] unless i == x
				  end
				end
			end

			module Diagonal
				def diagonal_moves x=px, y=py
				  (1..6).each_with_object([]) do |i,a|
				  	a << [x+i, y+i]
				    a << [x-i, y-i]
				    a << [x+i, y-i]
				    a << [x-i, y+1]
				  end
				end
			end
		end

		module Lshapable
			def possible_moves
				x = [2, 1, -1, -2, -2, -1, 1, 2];
    		y = [1, 2, 2, 1, -1, -2, -2, -1];
    		(0..7).each_with_object([]) do |i, a|
    			a << [px + x[i], py + y[i]]
    		end
			end
		end

		module Adjoinable
			def possible_moves
				@possible_moves = [
					        [px+1, py], [px+1, py+1], [px, py+1], [px-1, py+1],
					        [px-1, py], [px-1, py-1], [px, py-1], [px+1, py-1]
					      ]
				@possible_moves << kingside_castle if valid_castle? :kingside
				@possible_moves << queenside_castle if valid_castle? :queenside

				@possible_moves
			end
		end
	end
end