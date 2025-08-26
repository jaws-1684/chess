require "chess/piece"
require "chess/board"
require 'chess/pieces/bishop'

module Chess
	describe Bishop do
		subject(:board) { Board.new(chess_set: false) }
		subject(:bishop) { described_class.new(:white, [4,4], board)}

		before do
			board.add_to_cell([4,4], bishop)
			board.current_player_color = :white
		end
		context "when valid move" do
			it "can move diagonally right" do
				bishop.destination_position = [7, 7]
				expect(subject.valid_move?).to be_truthy
			end
			it "can move diagonally left" do
				bishop.destination_position = [7, 1]
				expect(subject.valid_move?).to be_truthy
			end
			it "can move diagonally left down" do
				bishop.destination_position = [0, 0]
				expect(subject.valid_move?).to be_truthy
			end
			it "can move diagonally right down" do
				bishop.destination_position = [1, 7]
				expect(subject.valid_move?).to be_truthy
			end
			it "can attack enemy pieces along the path" do
				board.add_to_cell([5,5], Bishop.new(:black, [5, 5], board))
				bishop.destination_position = [5, 5]
				expect(subject.valid_move?).to be_truthy
			end

		end
		context "when invalid move" do
			it "cannot move horizotally up" do
				bishop.destination_position = [5, 4]
				expect(subject.valid_move?).to be_falsey
			end
			it "cannot move horizotally down" do
				bishop.destination_position = [3, 4]
				expect(subject.valid_move?).to be_falsey
			end
				it "cannot move horizotally left" do
				bishop.destination_position = [4, 5]
				expect(subject.valid_move?).to be_falsey
			end
			it "cannot move horizotally right" do
				bishop.destination_position = [4, 3]
				expect(subject.valid_move?).to be_falsey
			end
			it "doesnt move out of bounds" do
				bishop.destination_position = [-1, -1]
				expect(subject.valid_move?).to be_falsey
			end
			it "doesnt move over pieces" do
				board.add_to_cell([5,5], Bishop.new(:black, [5, 5], board))
				bishop.destination_position = [7, 7]
				expect(subject.valid_move?).to be_falsey
			end
			it "cannot attack friendly pieces" do
				board.add_to_cell([5,5], Bishop.new(:white, [5, 5], board))
				bishop.destination_position = [5, 5]
				expect(subject.valid_move?).to be_falsey
			end
		end
	end
end