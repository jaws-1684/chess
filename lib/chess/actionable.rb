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
			def valid_pawn_attack? position
				board.valid_position?(position) && piece(position)&.enemy?(self) 
		  end

		  def valid_pawn_move? position
		  	board.valid_position?(position) && !board.is_a_piece?(position)
		  end

			def possible_moves
				@possible_moves = Array.new
				@possible_moves << step if valid_pawn_move?(step)
				@possible_moves << double_step if first_move? && valid_pawn_move?(double_step)

				@possible_moves << attack_right if valid_pawn_attack?(attack_right)
				@possible_moves << attack_left if valid_pawn_attack?(attack_left)
				@possible_moves << board.rememberable.dig(:enpassant_pawn, :passed_square) if valid_enpassant_attack?
			
				@possible_moves
			end
		end

		module Slidable
			module Straight
				def straight_moves
				  (0..7).each_with_object([]) do |i,a|
				    a << [px,i] unless i == py
				    a << [i,py] unless i == px
				  end.uniq
				end
			end

			module Diagonal
				def diagonal_moves
				  (0..7).each_with_object([]) do |i,a|
				  	a << [px+i, py+i]
				    a << [px-i, py-i]
				    a << [px+i, py-i]
				    a << [px-i, py+i]
				  end.uniq
				end
			end
		end

		module Lshapable
			def possible_moves
				x = [2, 1, -1, -2, -2, -1, 1, 2];
    		y = [1, 2, 2, 1, -1, -2, -2, -1];
    		(0..7).each_with_object([]) do |i, a|
    			a << [px + x[i], py + y[i]]
    		end.uniq
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