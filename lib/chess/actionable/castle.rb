module Chess
	module Actionable
		 module Castle
    def rook(place)
      positions = {
        queenside: 0,
        kingside: 7
      }
      piece = board[px, positions[place]]
      piece if piece&.name == :rook && piece.friendly?(self)
    end

    def rook_move!(type)
      rook(type).destination_position = yield
      rook(type).move!
    end

    def safe_adjacent_square?(type)
      # checking only the py+1 right and py-1 left squares cause the destination position is checked in the superclass and
      # the rook itself checks if its putting the king in check
      case type
      when :kingside
        !board.square_under_attack?([px, py + 1])
      when :queenside
        !board.square_under_attack?([px, py - 1])
      end
    end

    def kingside_castle
      [px, py + 2]
    end

    def queenside_castle
      [px, py - 2]
    end

    def castle_move?
      (destination_position == kingside_castle) || (destination_position == queenside_castle)
    end

    def valid_castle?(type)
      # returns false if king is under attack
      return false if board.square_under_attack?(current_position)

      !has_moved? && !rook(type).nil? && !rook(type).has_moved? && safe_adjacent_square?(type)
    end

    def castle!
      case destination_position
      when kingside_castle
        rook_move!(:kingside) { [px, 5] }
      when queenside_castle
        rook_move!(:queenside) { [px, 3] }
      end
    end
  end
	end
end