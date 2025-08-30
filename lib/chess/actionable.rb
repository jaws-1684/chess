module Chess
	module Actionable
		module Stepable
			PAWN_MOVES = [:step, :double_step, :attack_left, :attack_right,]

			def possible_moves			
				possible_moves = [
													[px + direction, py],
													[px + (2 * direction), py], 
													[px+direction, py-direction], 
													[px+direction, py+direction] 
												]
			end

			PAWN_MOVES.each_with_index do |m, idx|
				define_method(m) { possible_moves[idx] }
			end

			def enpassant
				board.rememberable.dig(:enpassant_pawn, :passed_square)
			end

			def valid_moves
        super do |pmove|
          case pmove
          	#selection the the results of the superclass only the spefic valid pawn moves
          	#also its ensuring no friendly attack or out_of_bounds board positions can be valid
            when step then !board.is_a_piece?(pmove)
            when double_step then self.first_move? && !board.is_a_piece?(pmove)
            when enpassant then valid_enpassant_attack?   
            #no need to check for specific attacks cause at this point only attack will remain valid if any valid move exists	
            else piece(pmove)&.enemy?(self) 
          end
        end
      end
		end

		module Slidable
			#theese methods are aliesed in the pieces classes so they can be used be the queen too
			module Straight
				def straight_moves
				  possible_moves = (0..7).each_with_object([]) do |i,a|
				    a << [px,i] unless i == py
				    a << [i,py] unless i == px
				  end.uniq
				end
			end

			module Diagonal
				def diagonal_moves
				  possible_moves = (0..7).each_with_object([]) do |i,a|
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
    		possible_moves = (0..7).each_with_object([]) do |i, a|
    			a << [px + x[i], py + y[i]]
    		end.uniq
			end
		end

		module Adjoinable
			def possible_moves
				possible_moves = [
					        [px+1, py], [px+1, py+1], [px, py+1], [px-1, py+1],
					        [px-1, py], [px-1, py-1], [px, py-1], [px+1, py-1], 
					        [px, py+2], [px, py-2]
					      ]
			end
			def valid_moves
				super do |pmove|
					case pmove
						when kingside_castle then valid_castle?(:kingside)
						when queenside_castle then valid_castle?(:queenside)
						else true	
					end
				end
			end
		end
	end
end