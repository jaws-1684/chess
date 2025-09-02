# frozen_string_literal: true

require 'chess/piece'
require 'chess/board'
require 'chess/pieces/pawn'
require 'colorize'
module Chess
  describe Pawn do
    subject(:board) { Board.new(chess_set: false) }

    before do
      $stdout = StringIO.new
    end

    context 'when white' do
      subject(:pawn) { described_class.new(:white, [1, 1], board) }
      before do
        board.add_to_cell([1, 1], pawn)
        board.current_player_color = :white
      end

      it 'can step' do
        subject.destination_position = [2, 1]
        expect(subject.valid_move?).to eq true
      end
      it 'can double step on the first move' do
        subject.destination_position = [3, 1]
        expect(subject.valid_move?).to eq true
      end
      it 'can attack diagonally left' do
        enemy = described_class.new(:black, [2, 0], board)
        board.add_to_cell([2, 0], enemy)
        subject.destination_position = [2, 0]
        expect(subject.valid_move?).to eq true
      end
      it 'can attack diagonally right' do
        enemy = described_class.new(:black, [2, 2], board)
        board.add_to_cell([2, 2], enemy)
        subject.destination_position = [2, 2]
        expect(subject.valid_move?).to eq true
      end

      it 'cannot double step if the path is not clear' do
        enemy = described_class.new(:white, [2, 1], board)
        board.add_to_cell([2, 1], enemy)
        subject.destination_position = [3, 1]
        expect(subject.valid_move?).to eq false
      end

      it 'cannot double_step if its not the first move' do
        subject.destination_position = [3, 1]
        subject.move!
        subject.destination_position = [5, 1]
        expect(subject.valid_move?).to eq false
      end
      it 'cannot move backwards' do
        subject.destination_position = [0, 1]
        expect(subject.valid_move?).to eq false
      end
      it 'cannot move diagonally if the square is empty' do
        subject.destination_position = [2, 2]
        expect(subject.valid_move?).to eq false
      end
      it 'cannot step forward if the squre is occupied' do
        enemy = described_class.new(:black, [2, 1], board)
        board.add_to_cell([2, 1], enemy)
        subject.destination_position = [2, 1]
        expect(subject.valid_move?).to eq false
      end

      context 'when enpassant' do
        let(:enemy) { described_class.new(:black, [3, 0], board) }
        before do
          board.add_to_cell([3, 0], enemy)
          subject.destination_position = [3, 1]
          subject.move!
          board.current_player_color = :black
        end
        it 'removes the original pawn when attacked' do
          enemy.destination_position = [2, 1]
          enemy.move!
          expect(board[3, 1]).to be_nil
        end
        it 'markes the passed square' do
          expect(board.rememberable[:enpassant_pawn][:passed_square]).to eq [2, 1]
        end
        it 'unmarkes position if not attacked in the next move' do
          enemy.destination_position = [2, 0]
          enemy.move!
          expect(board.rememberable[:enpassant_pawn]).to be_nil
        end
        it 'sets the enpassant flag' do
          expect(subject.enpassant_vulnerable?).to be_truthy
        end
        it 'resets the enpassant flag' do
          enemy.destination_position = [2, 0]
          enemy.move!
          expect(subject.enpassant_vulnerable?).to be_falsey
        end
      end
    end

    context 'when black' do
      subject(:pawn) { described_class.new(:black, [6, 1], board) }
      before do
        board.add_to_cell([6, 1], pawn)
        board.current_player_color = :black
      end

      it 'can step' do
        subject.destination_position = [5, 1]
        expect(subject.valid_move?).to eq true
      end

      it 'can double step on the first move' do
        subject.destination_position = [4, 1]
        expect(subject.valid_move?).to eq true
      end

      it 'can attack diagonally left' do
        enemy = described_class.new(:white, [5, 0], board)
        board.add_to_cell([5, 0], enemy)
        subject.destination_position = [5, 0]
        expect(subject.valid_move?).to eq true
      end

      it 'can attack diagonally right' do
        enemy = described_class.new(:white, [5, 2], board)
        board.add_to_cell([5, 2], enemy)
        subject.destination_position = [5, 2]
        expect(subject.valid_move?).to eq true
      end
      it 'cannot double step if the path is not clear' do
        enemy = described_class.new(:white, [5, 1], board)
        board.add_to_cell([5, 1], enemy)
        subject.destination_position = [4, 1]
        expect(subject.valid_move?).to eq false
      end
      it 'cannot double_step if its not the first move' do
        subject.destination_position = [4, 1]
        subject.move!
        subject.destination_position = [2, 1]
        expect(subject.valid_move?).to eq false
      end

      it 'cannot move backwards' do
        subject.destination_position = [5, 1]
        subject.move!
        subject.destination_position = [6, 1]
        expect(subject.valid_move?).to eq false
      end

      it 'cannot move diagonally if the square is empty' do
        subject.destination_position = [5, 2]
        expect(subject.valid_move?).to eq false
      end

      it 'cannot step forward if the square is occupied' do
        enemy = described_class.new(:white, [5, 1], board)
        board.add_to_cell([5, 1], enemy)
        subject.destination_position = [5, 1]
        expect(subject.valid_move?).to eq false
      end

      context 'when enpassant' do
        let(:enemy) { described_class.new(:white, [4, 2], board) }
        before do
          board.add_to_cell([4, 2], enemy)
          subject.destination_position = [4, 1]
          subject.move!
          board.current_player_color = :white
        end
        it 'removes the original pawn when attacked' do
          enemy.destination_position = [5, 1]
          enemy.move!
          expect(board[4, 1]).to be_nil
        end
        it 'markes the passed square' do
          expect(board.rememberable[:enpassant_pawn][:passed_square]).to eq [5, 1]
        end
        it 'unmarkes position if not attacked in the next move' do
          enemy.destination_position = [5, 2]
          enemy.move!
          expect(board.rememberable[:enpassant_pawn]).to be_nil
        end
        it 'sets the enpassant flag' do
          expect(subject.enpassant_vulnerable?).to be_truthy
        end
        it 'resets the enpassant flag' do
          enemy.destination_position = [5, 2]
          enemy.move!
          expect(subject.enpassant_vulnerable?).to be_falsey
        end
      end
    end
  end
end
