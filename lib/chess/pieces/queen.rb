# frozen_string_literal: true

module Chess
  module Pieces
    class Queen < Piece
      attr_reader :name, :score

      def initialize(color, current_position, board)
        super(color, current_position, board)
        @name = :queen
        @score = 9
      end

      def move!
        super
        basic_move
      end

      def possible_moves
        straight_moves + diagonal_moves
      end

      private

      include Actionable::Slidable::Straight
      include Actionable::Slidable::Diagonal
      def assign_symbol
        color == :white ? '♕' : '♛'
      end
    end
  end
end
