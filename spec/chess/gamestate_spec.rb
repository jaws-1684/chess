require 'chess/validatable'
require 'chess/board'
require 'chess/piece'
require "colorize"

module Chess
	describe Board do
		subject(:board) { board = Board.new(populate: false) }
		before do
			board.current_player_color = :black 
			board.grid = Array.new(8) { Array.new(8) }
			king = King.new(:black, [7,2], board)
			board.add_to_cell([7, 2], king)
		end
		

	describe "#in_check?" do
		context "when king is in check" do
			it "should be_truthy" do
				enemy = Rook.new(:white, [7, 7], board)
				board.add_to_cell([7, 7], enemy)
				expect(board.in_check?).to be_truthy
			end
		end

		context "when king is not in_check" do
			it  "should be_falsey" do
				expect(board.in_check?).to be_falsey
			end
		end
	end
	describe "#in_checkmate?" do
		context "when king is in check_mate" do
			it  "should be_truthy" do
				enemy = Rook.new(:white, [7, 7], board)
				board.add_to_cell([7, 7], enemy)
				enemy1 = Rook.new(:white, [6, 7], board)
				board.add_to_cell([6, 7], enemy1)
				expect(board.in_checkmate?).to be_truthy
			end
		end

		context "when king is not in_checkmate" do

			it "should be_falsey" do
				enemy = Rook.new(:white, [7, 7], board)
				board.add_to_cell([7, 7], enemy)
				ally = Rook.new(:black, [7, 5], board)
				board.add_to_cell([7,5], ally)
				expect(board.in_checkmate?).to be_falsey
			end
		end
	end
		

	end
end
