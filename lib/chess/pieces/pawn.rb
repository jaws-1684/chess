# frozen_string_literal: true

module Chess
  module Pieces
    class Pawn < Piece
      attr_reader :name, :first_move, :direction, :score
      attr_accessor :enpassant_vulnerable
      alias enpassant_vulnerable? enpassant_vulnerable
      alias first_move? first_move

      def initialize(color, current_position, board)
        super(color, current_position, board)
        @name = :pawn
        @direction = color == :white ? 1 : -1
        @first_move = true
        @enpassant_vulnerable = false
        @score = 1
      end

      def move!
        super
        basic_move do
          if enpassant_vulnerable_move?
            @enpassant_vulnerable = true
            board.rememberable.memoize(:enpassant_pawn, color: color, passed_square: [px + direction, py],
                                                        current_square: destination_position)
          end

          if enpassant_capture?
            board.captured_pieces << enpassant_enemy
            destroy_enemy!
            board.rememberable.destroy!(:enpassant_pawn)
          end

          @first_move = false
        end
        return unless final_row?

        promote! unless board.computer
        auto_promote! if board.computer
      end

      private

      include Actionable::Stepable
      include Actionable::Enpassant
      include Actionable::Promotion
      def assign_symbol
        color == :white ? '♙' : '♟'
      end
    end
  end
end
