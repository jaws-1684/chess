module Chess
	module Validatable
		module Path
			def path_clear?
        x_step = dx <=> px
        y_step = dy <=> py 
        current_x = px + x_step
        current_y = py + y_step
        until current_x == dx && current_y == dy
          return false unless board.clear_destination?([current_x, current_y])
          current_x += x_step
          current_y += y_step
        end  
        true
      end
		end

		module Stepable
			def possible_moves
				@possible_moves = {
					step: [px + direction, py],
					double_step: [px + (2 * direction), py],
					attack_right: [px+direction, py+direction],
					attack__left: [px+direction, py-direction]
				}
				OpenStruct.new(@possible_moves)
			end
			def safe_moves   
	      super(possible_moves.to_h.values.select(&valid))
    	end
		  def valid_attack?
		  	(dx - px).abs == (dy - py).abs && (dx - px) == direction
		  end
		  def valid_move?
		  	return true if !!enemy && valid_attack?
		  	return false if board.is_a_piece?(destination_position)	
		    moves = [possible_moves.step]
		    moves << possible_moves.double_step if first_move
		      
		    moves.include?(destination_position) 
		  end
		end

		module Slidable
			module Straight
				def possible_moves x=px, y=py
				  (0..7).each_with_object([]) do |i,a|
				    a << [x,i] unless i == y
				    a << [i,y] unless i == x
				  end.select(&valid)
				end
			  def valid_move?
			   	px == dx || py == dy
			  end
			end

			module Diagonal
				def possible_moves x=px, y=py
				  (1..6).each_with_object([]) do |i,a|
				  	a << [x+i, y+i]
				    a << [x-i, y-i]
				    a << [x+i, y-i]
				    a << [x-i, y+1]
				  end.select(&valid)
				end
				def valid_move?
					(dx - px).abs == (dy - py).abs
				end
			end
			module All
				def possible_moves x=px, y=py
				  (1..7).each_with_object([]) do |i,a|
				  	a << [x,i] unless i == y
				    a << [i,y] unless i == x
				  	a << [x+i, y+i]
				    a << [x-i, y-i]
				    a << [x+i, y-i]
				    a << [x-i, y+1]
				  end.select(&valid)
				end
				def valid_move?
					(px == dx || py == dy) || ((dx - px).abs == (dy - py).abs)
				end
			end
		end

		module Lshapable
			def path_clear?
				true
			end
			def possible_moves
				x = [2, 1, -1, -2, -2, -1, 1, 2];
    		y = [1, 2, 2, 1, -1, -2, -2, -1];
    		(0..7).each_with_object([]) do |i, a|
    			a << [px + x[i], py + y[i]]
    		end.select {|move| board.valid_position?(move) && !board[move[0], move[1]]&.friendly?(self) }
    		# @possible_moves = [
				# 		      [px+2, py+1], [px+2, py-1], [px-2, py+1], [px-2, py-1],
				# 		      [px+1, py+2], [px+1, py-2], [px-1, py+2], [px-1, py-2]
				#     		]
			end
			def valid_move?
				possible_moves.include?(destination_position)    		
			end
		end

		module Adjoinable
			def possible_moves
				@possible_moves = {
					base: [
					        [px+1, py], [px+1, py+1], [px, py+1], [px-1, py+1],
					        [px-1, py], [px-1, py-1], [px, py-1], [px+1, py-1]
					      ],
					kingside_castle: [px, py+2],
					queenside_castle: [px, py-2]      
				}
				OpenStruct.new(@possible_moves)
			end
			def safe_moves
				super(possible_moves.base.select(&valid))
			end
			def valid_move?
				return false if piece&.friendly?(self)
				moves = possible_moves.base
				if valid_castle? :kingside
					moves << possible_moves.kingside_castle
				end	
				if valid_castle? :queenside
					moves << possible_moves.queenside_castle
				end 
				moves.include?(destination_position)	      
			end
		end
	end
end