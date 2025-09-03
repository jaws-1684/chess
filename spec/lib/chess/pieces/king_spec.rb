# frozen_string_literal: true

require 'spec_helper'
module Chess
  module Pieces
    describe King do
      subject(:board) { Board.new(chess_set: false) }
      subject(:king) { described_class.new(:white, [0, 4], board) }
      before do
        board.add_to_cell([0, 4], king)
        board.current_player_color = :white
        $stdout = StringIO.new
      end
      context 'when valid move' do
        it 'should move to the adjoinable squares' do
          [[0, 5], [0, 3], [1, 5], [1, 3], [1, 4]].each do |pos|
            king.destination_position = pos
            expect(king.valid_move?).to be_truthy
          end
        end
        it 'can kingside castle if on the first move' do
          rook = Rook.new(:white, [0, 7], board)
          board.add_to_cell([0, 7], rook)
          king.destination_position = [0, 6]
          king.move!
          expect(board[0, 6]).to be_a(King)
          expect(board[0, 5]).to be_a(Rook)
        end
        it 'can queenside castle if on the first move' do
          rook = Rook.new(:white, [0, 0], board)
          board.add_to_cell([0, 0], rook)
          king.destination_position = [0, 2]
          king.move!
          expect(board[0, 2]).to be_a(King)
          expect(board[0, 3]).to be_a(Rook)
        end
      end
      context 'when invalid move' do
        it 'cannot slide' do
          king.destination_position = [2, 2]
          expect(king.valid_move?).to be_falsey
        end
        # altought i am testing in some another test(bishop test specifically) that a piece cannot leave its king in check
        # this should suffice since all pieces use the same method
        it 'should not move into check' do
          rook = Rook.new(:black, [7, 3], board)
          board.add_to_cell([7, 3], rook)

          king.destination_position = [0, 3]
          expect(king.safe_move?).to be_falsey
        end
        it 'can not kingside castle if has moved' do
          rook = Rook.new(:white, [0, 7], board)
          board.add_to_cell([0, 7], rook)

          # simulation the move
          king.destination_position = [1, 4]
          king.move!
          king.destination_position = [0, 4]
          king.move!

          king.destination_position = [0, 6]
          expect(king.valid_move?).to be_falsey
        end
        it 'can not queenside castle if has moved' do
          rook = Rook.new(:white, [0, 0], board)
          board.add_to_cell([0, 0], rook)

          king.destination_position = [1, 4]
          king.move!
          king.destination_position = [0, 4]
          king.move!

          king.destination_position = [0, 2]
          expect(king.valid_move?).to be_falsey
        end
        it 'can not kingside castle if rook moved' do
          rook = Rook.new(:white, [7, 7], board)
          board.add_to_cell([7, 7], rook)

          # simulation the move
          rook.destination_position = [0, 7]
          rook.move!

          king.destination_position = [0, 6]
          expect(king.valid_move?).to be_falsey
        end
        it 'can not queenside castle if rook moved' do
          rook = Rook.new(:white, [7, 0], board)
          board.add_to_cell([7, 0], rook)

          rook.destination_position = [0, 0]
          rook.move!

          king.destination_position = [0, 2]
          expect(king.valid_move?).to be_falsey
        end
        it 'can not kingside castle if in check' do
          enemy = Rook.new(:black, [7, 4], board)
          board.add_to_cell([7, 4], enemy)

          rook = Rook.new(:white, [0, 7], board)
          board.add_to_cell([0, 7], rook)

          board.set_squares_under_attack!
          king.destination_position = [0, 6]
          expect(king.safe_move?).to be_falsey
        end
        it 'can not queenside castle if in check' do
          enemy = Rook.new(:black, [7, 4], board)
          board.add_to_cell([7, 4], enemy)

          rook = Rook.new(:white, [0, 0], board)
          board.add_to_cell([0, 0], rook)

          board.set_squares_under_attack!
          king.destination_position = [0, 2]
          expect(king.safe_move?).to be_falsey
        end
        it 'can not kingside castle if right square is under attack' do
          enemy = Rook.new(:black, [7, 5], board)
          board.add_to_cell([7, 5], enemy)

          rook = Rook.new(:white, [0, 7], board)
          board.add_to_cell([0, 7], rook)

          board.set_squares_under_attack!
          king.destination_position = [0, 6]
          expect(king.safe_move?).to be_falsey
        end
        it 'can not queenside castle if left square is under attack' do
          enemy = Rook.new(:black, [7, 3], board)
          board.add_to_cell([7, 3], enemy)
          rook = Rook.new(:white, [0, 0], board)
          board.add_to_cell([0, 0], rook)
          board.set_squares_under_attack!

          king.destination_position = [0, 2]
          expect(king.safe_move?).to be_falsey
        end
      end
    end
  end
end
