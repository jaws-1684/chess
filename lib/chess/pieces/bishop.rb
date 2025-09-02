# frozen_string_literal: true

module Chess
  class Bishop < Piece
    attr_reader :name, :score

    def initialize(color, current_position, board)
      super(color, current_position, board)
      @name = :bishop
      @score = 3
    end

    def move!
      super
      basic_move
    end

    private

    include Actionable::Slidable::Diagonal
    def assign_symbol
      color == :white ? '♗' : '♝'
    end
    alias possible_moves diagonal_moves
  end
end
