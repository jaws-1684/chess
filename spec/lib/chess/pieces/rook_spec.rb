# frozen_string_literal: true

require "spec_helper"

module Chess
  module Pieces
  describe Rook do
    subject(:board) { Board.new(chess_set: false) }
    subject(:rook) { described_class.new(:white, [4, 4], board) }

    before do
      board.add_to_cell([4, 4], rook)
      board.current_player_color = :white
    end
    context 'when valid move' do
      it 'can move horizontally up' do
        rook.destination_position = [7, 4]
        expect(subject.valid_move?).to be_truthy
      end
      it 'can move horizontally down' do
        rook.destination_position = [0, 4]
        expect(subject.valid_move?).to be_truthy
      end
      it 'can move horizontally left' do
        rook.destination_position = [4, 0]
        expect(subject.valid_move?).to be_truthy
      end
      it 'can move horizontally right' do
        rook.destination_position = [4, 7]
        expect(subject.valid_move?).to be_truthy
      end
      it 'can attack enemy pieces along the path' do
        board.add_to_cell([5, 4], Rook.new(:black, [5, 4], board))
        rook.destination_position = [5, 4]
        expect(subject.valid_move?).to be_truthy
      end
    end
    context 'when invalid move' do
      it 'cannot move diagonnaly up right' do
        rook.destination_position = [5, 5]
        expect(subject.valid_move?).to be_falsey
      end
      it 'cannot move diagonnaly up left' do
        rook.destination_position = [5, 3]
        expect(subject.valid_move?).to be_falsey
      end
      it 'cannot move diagonnaly down left' do
        rook.destination_position = [3, 3]
        expect(subject.valid_move?).to be_falsey
      end
      it 'cannot move diagonnaly down right' do
        rook.destination_position = [3, 5]
        expect(subject.valid_move?).to be_falsey
      end
      it 'doesnt move out of bounds' do
        rook.destination_position = [-8, -4]
        expect(subject.valid_move?).to be_falsey
      end
      it 'doesnt move over pieces' do
        board.add_to_cell([5, 4], Rook.new(:black, [5, 4], board))
        rook.destination_position = [7, 4]
        expect(subject.valid_move?).to be_falsey
      end
      it 'cannot attack friendly pieces' do
        board.add_to_cell([5, 4], Rook.new(:white, [5, 4], board))
        rook.destination_position = [5, 4]
        expect(subject.valid_move?).to be_falsey
      end
    end
  end
end
end
