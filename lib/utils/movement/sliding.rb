require_relative '../paths/verticals'
require_relative '../paths/horizontals'
require_relative '../paths/diagonals'

module Slide
	include MoveVertical
  include MoveHorizontal
  include MoveDiagonally 
 
	def vertical_slide?(move)
		 vertical_path?(move)
	end

	def horizontal_slide?(move)
		horizontal_path?(move)
	end
	
	def diagonal_slide(move)
		diagonal_path?(move)
	end
end