# frozen_string_literal: true

module Chess
  module Gamestate
    def in_check?
      enemies.any? { |enemy| enemy.can_attack?(king_position) }
    end

    def in_checkmate?
      return false unless in_check?

      players_pieces.none?(&:any_safe_moves?)
    end

    def in_stalemate?
      !in_check? && players_pieces.none?(&:any_safe_moves?)
    end
  end
end
