# frozen_string_literal: true

module Chess
  module Pieces
    class Knight < Piece
      attr_reader :name, :score

      def initialize(color, current_position, board)
        super(color, current_position, board)
        @name = :knight
        @score = 3
      end

      def move!
        super
        basic_move
      end

      private

      include Actionable::Lshapable
      def assign_symbol
        color == :white ? '♘' : '♞'
      end
    end
  end
end
