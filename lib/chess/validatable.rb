module Chess
	module Validatable
		def path_clear? current_position, destination_position
			return true if select_square(current_position).is_a?(Knight)
			unpack(current_position) do |px, py|
				unpack(destination_position) do |dx, dy|
		      x_step = dx <=> px
		      y_step = dy <=> py 
		      current_x = px + x_step
		      current_y = py + y_step
		      until current_x == dx && current_y == dy
		        return false unless self.clear_destination?([current_x, current_y])
		        current_x += x_step
		        current_y += y_step
		      end  
		      true
		    end
		  end
    end
    def valid_position? position
      position[0].between?(0,7) && position[1].between?(0,7)
    end
    def is_a_piece? position, kind=Piece
      unpack(position) { |x, y|  @grid[x][y].is_a? kind }
    end
    def clear_destination? position
    	return false unless valid_position?(position)
      unpack(position) { |x, y|  @grid[x][y] == nil }
    end
    
	end
end