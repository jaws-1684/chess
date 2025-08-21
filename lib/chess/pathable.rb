module Chess
	module Pathable
		module Generator
			def path_between attacker_position
      self.destination_position = attacker_position
      path = []
      x_step = dx <=> self.px
      y_step = dy <=> self.py 
      current_x = self.px + x_step
      current_y = self.py + y_step

      until current_x == dx && current_y == dy
        path << [current_x, current_y]
        current_x += x_step
        current_y += y_step
      end
      path
      ensure
        self.destination_position = []
    	end
		end
	end
end