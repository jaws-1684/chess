# frozen_string_literal: true

require 'chess/game'

module Chess
  describe Board do
    King = Pieces::King
    Queen = Pieces::Queen
    Rook = Pieces::Rook
    Bishop = Pieces::Bishop
    Knight = Pieces::Knight
    Pawn = Pieces::Pawn
    
    describe '#in_check?' do
      subject(:board) { described_class.new(chess_set: false) }
      before do
        board.add_to_cell([7, 0], King.new(:black, [7, 0], board))
        board.current_player_color = :black
      end
      context 'when king is in check' do
        it 'should be_truthy' do
          board.add_to_cell([7, 7], Rook.new(:white, [7, 7], board))
          board.set_squares_under_attack!
          expect(board.in_check?).to be_truthy
        end
      end

      context 'when king is not in_check' do
        it 'should be_falsey' do
          board.add_to_cell([6, 7], Rook.new(:white, [6, 7], board))
          board.set_squares_under_attack!
          expect(board.in_check?).to be_falsey
        end
      end
    end

    describe '#in_checkmate?' do
      context 'when is in check_mate with two rooks' do
        subject(:board) { described_class.new(chess_set: false) }
        before do
          board.add_to_cell([7, 0], King.new(:black, [7, 0], board))
          enemy = Rook.new(:white, [7, 6], board)
          board.add_to_cell([7, 6], enemy)

          enemy1 = Rook.new(:white, [6, 7], board)
          board.add_to_cell([6, 7], enemy1)

          white_king = King.new(:white, [0, 1], board)
          board.add_to_cell([0, 1], white_king)
          board.current_player_color = :black
          board.set_squares_under_attack!
        end
        it 'should be_truthy' do
          expect(board.in_checkmate?).to be_truthy
        end
      end
      context 'when is in check_mate with king and queen' do
        subject(:board) { described_class.new(chess_set: false) }
        before do
          board.add_to_cell([1, 7], King.new(:black, [1, 7], board))
          board.current_player_color = :black
        end
        it 'should be_truthy' do
          enemy = Queen.new(:white, [1, 6], board)
          board.add_to_cell([1, 6], enemy)
          white_king = King.new(:white, [1, 5], board)
          board.add_to_cell([1, 5], white_king)
          board.set_squares_under_attack!
          expect(board.in_checkmate?).to be_truthy
        end
      end
      context 'when is in checkmate with king and one rook' do
        subject(:board) { described_class.new(chess_set: false) }
        before do
          board.add_to_cell([7, 6], King.new(:black, [7, 6], board))
          board.current_player_color = :black
        end
        it 'should be_truthy' do
          enemy = Rook.new(:white, [7, 1], board)
          board.add_to_cell([7, 1], enemy)
          white_king = King.new(:white, [5, 6], board)
          board.add_to_cell([5, 6], white_king)
          board.set_squares_under_attack!
          expect(board.in_checkmate?).to be_truthy
        end
      end
      context 'when is in checkmate with king and two bishops' do
        subject(:board) { described_class.new(chess_set: false) }
        before do
          board.add_to_cell([0, 7], King.new(:black, [0, 7], board))
          board.current_player_color = :black
        end
        it 'should be_truthy' do
          white_king = King.new(:white, [2, 6], board)
          board.add_to_cell([2, 6], white_king)

          first_bishop = Bishop.new(:white, [4, 3], board)
          board.add_to_cell([4, 3], first_bishop)

          second_bishop = Bishop.new(:white, [2, 4], board)
          board.add_to_cell([2, 4], second_bishop)
          board.set_squares_under_attack!
          expect(board.in_checkmate?).to be_truthy
        end
      end
      context 'when is in checkmate with king, bishop and knight' do
        subject(:board) { described_class.new(chess_set: false) }
        before do
          board.add_to_cell([7, 0], King.new(:black, [7, 0], board))
          board.current_player_color = :black
        end

        it 'should be_truthy' do
          white_king = King.new(:white, [5, 1], board)
          board.add_to_cell([5, 1], white_king)

          bishop = Bishop.new(:white, [3, 4], board)
          board.add_to_cell([3, 4], bishop)

          knight = Knight.new(:white, [5, 0], board)
          board.add_to_cell([5, 0], knight)
          board.set_squares_under_attack!
          expect(board.in_checkmate?).to be_truthy
        end
      end
      context 'when king is not in_checkmate' do
        subject(:board) { described_class.new(chess_set: false) }
        before do
          board.add_to_cell([1, 7], King.new(:black, [1, 7], board))
          board.current_player_color = :black
        end
        it 'should be_falsey' do
          enemy = Rook.new(:white, [7, 7], board)
          board.add_to_cell([7, 7], enemy)
          ally = Rook.new(:black, [7, 5], board)
          board.add_to_cell([7, 5], ally)
          board.set_squares_under_attack!
          expect(board.in_checkmate?).to be_falsey
        end
      end
    end

    describe '#in_stalemate?' do
      context 'when in stalemate' do
        subject(:board) { described_class.new(chess_set: false) }
        before do
          board.add_to_cell([7, 0], King.new(:black, [7, 0], board))
          board.current_player_color = :black
        end

        it 'should be_truthy' do
          queen = Queen.new(:white, [6, 2], board)
          board.add_to_cell([6, 2], queen)

          king = King.new(:white, [3, 2], board)
          board.add_to_cell([3, 2], king)
          board.set_squares_under_attack!
          expect(subject.in_stalemate?).to be_truthy
        end
      end
    end
  end
end
