require 'chess/validatable'
require 'chess/board'
require 'chess/piece'
require "colorize"

module Chess
	describe Board do
		subject(:board) { board = Board.new }
		before do
			board.current_player_color = :black 
			board.grid = Array.new(8) { Array.new(8) }
			king = King.new(:black, [7,2], board)
			board.add_to_cell([7, 2], king)

			enemy = Rook.new(:white, [7, 7], board)
			board.add_to_cell([7, 7], enemy)
		end
		

	describe "#in_check?" do
		subject(:in_check) { board.in_check? }
		let(:king) { board.king }
		context "when king is in check" do
			it { should be_truthy }
		end

		context "when king is not in_check" do
			before do
				board.clear_cell([7, 7])
			end
			it { should be_falsey }
		end
	end
	describe "#in_checkmate?" do
		subject(:in_check_mate) { board.in_checkmate? }
		let(:king) { board.king }
		context "when king is in check_mate" do
			before do
				enemy = Rook.new(:white, [6, 7], board)
				board.add_to_cell([6, 7], enemy) 
			end
			it { should be_truthy }
			it "has not any safe moves" do
			end
		end

		context "when king is not in_checkmate" do
			it { should be_falsey }
		end
	end
		

	end
end
