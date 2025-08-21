module Chess
	module Gamestate
		module Check
			def in_check? 
				enemies.any? { |enemy| enemy.can_attack?(king.current_position) }
			end
		end

		module Checkmate
			
			def in_checkmate?
				return false unless in_check?
				players_pieces.none?(&:any_safe_moves?)
			end
			def stalemate?
				!in_check? && players_pieces.none?(&:any_safe_moves?)
			end
		end
	end
end