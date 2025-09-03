# frozen_string_literal: true

module Chess
  module Pieces
    class King < Piece
      attr_reader :name, :has_moved, :score
      alias has_moved? has_moved

      def initialize(color, current_position, board)
        super(color, current_position, board)
        @name = :king
        @has_moved = false
        @score = 999
      end

      def move!
        super
        basic_move do
          castle! if castle_move?
          @has_moved = true
        end
      end

      def basic_move(board = self.board, &block)
        super(board) do
          board.rememberable.memoize("#{color}_king", position: destination_position)
          block.call if block_given?
        end
      end

      private

      include Actionable::Castle
      include Actionable::Adjoinable
      def assign_symbol
        color == :white ? '♔' : '♚'
      end
    end
  end
end
