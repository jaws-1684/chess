module Chess
	module Validator
		module Path
			def path_clear?
        x_step = dx <=> px
        y_step = dy <=> py 
        current_x = px + x_step
        current_y = py + y_step
        loop do
          break if current_x == dx
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
					attack: []
				}
				OpenStruct.new(@possible_moves)
			end
		  def valid_attack?
		  	(dx - px).abs == (dy - py).abs && (dx - px) == direction
		  end
		  def valid_move?

		  	return true if !!enemy && valid_attack?
		  		
		    moves = [possible_moves.step]
		    moves << possible_moves.double_step if first_move
		      
		    moves.include?(destination_position) 
		  end
		end
		module Slidable
			module Straight
			  def valid_move?
			   	px == dx || py == dy
			  end
			end

			module Diagonal
				def valid_move?
					(dx - px).abs == (dy - py).abs
				end
			end
			module All
				def valid_move?
					(px == dx || py == dy) || ((dx - px).abs == (dy - py).abs)
				end
			end
		end
		module Lshapable
			def possible_moves
				@possible_moves = {
					base: [
						      [px+2, py+1], [px+2, py-1], [px-2, py+1], [px-2, py-1],
						      [px+1, py+2], [px+1, py-2], [px-1, py+2], [px-1, py-2]
				    		]
				}
				OpenStruct.new(@possible_moves)
			end
			def valid_move?
				possible_moves.base.include?(destination_position)    		
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
			def valid_castle? type
				!self.has_moved && (rook(type) != nil) && !rook(type).has_moved
			end
			def valid_move?
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