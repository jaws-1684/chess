# frozen_string_literal: true

require 'spec_helper'
module Chess
  module Pieces
    describe Knight do
      subject(:board) { Board.new(chess_set: false) }
      subject(:knight) { described_class.new(:white, [4, 4], board) }
      before do
        board.add_to_cell([4, 4], knight)
      end
      context 'when valid move' do
        it 'can move two squares up, then one square left or right.' do
          expect(knight.valid_moves.include?([6, 3])).to be_truthy
          expect(knight.valid_moves.include?([6, 5])).to be_truthy
        end
        it 'can move two squares down, then one square left or right.' do
          expect(knight.valid_moves.include?([2, 3])).to be_truthy
          expect(knight.valid_moves.include?([2, 5])).to be_truthy
        end
        it 'can move two squares left, then one square up or down.' do
          expect(knight.valid_moves.include?([3, 2])).to be_truthy
          expect(knight.valid_moves.include?([5, 2])).to be_truthy
        end
        it 'can move two squares right, then one square up or down.' do
          expect(knight.valid_moves.include?([3, 6])).to be_truthy
          expect(knight.valid_moves.include?([5, 6])).to be_truthy
        end
      end
      context 'when invalid move' do
        it 'cannot move straight left' do
          expect(knight.valid_moves.include?([4, 5])).not_to be_truthy
        end
        it 'cannot move straight right' do
          expect(knight.valid_moves.include?([4, 3])).not_to be_truthy
        end
        it 'cannot move straight up' do
          expect(knight.valid_moves.include?([5, 5])).not_to be_truthy
        end
        it 'cannot move straight down' do
          expect(knight.valid_moves.include?([3, 3])).not_to be_truthy
        end
      end
    end
  end
end
