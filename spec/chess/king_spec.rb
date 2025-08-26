require "chess/piece"
require "chess/board"
require 'chess/pieces/king'
require 'chess/pieces/rook'

module Chess
	describe King do
		subject(:board) { Board.new(chess_set: false) }
		subject(:king) { described_class.new(:white, [0, 4], board) }
		before do
			board.add_to_cell([0, 4], king)
			board.current_player_color = :white
		end
		context "when valid base move" do
			it "should move to the adjoinable squares"
				[[0, 5], [0, 3], [1, 5], [1, 3], [1, 4]].each do |pos|
					king.destination_position = pos
					expect(king.valid_move?).to be_truthy
				end
			end
		end
	end
end