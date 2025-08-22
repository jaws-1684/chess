require 'chess/board'
require 'chess/piece'
require "colorize"

module Chess
	describe Pawn do
		let(:board) { Board.new }
		before do
			$stdout = StringIO.new
			board.current_player_color = :white
		end

		context "when white" do
			subject(:pawn) { board[1, 1] }

			it "can step" do
				subject.destination_position = [2, 1]
				expect(subject.valid_move?).to eq true
			end
			it "can double step on the first move" do
				subject.destination_position = [3, 1]
				expect(subject.valid_move?).to eq true
			end
			it "can attack diagonally left" do
				enemy = described_class.new(:black, [2, 0], board)
				board.add_to_cell([2, 0], enemy)
				subject.destination_position = [2, 0]
				expect(subject.valid_move?).to eq true
			end
			it "can attack diagonally right" do
				enemy = described_class.new(:black, [2, 2], board)
				board.add_to_cell([2, 2], enemy)
				subject.destination_position = [2, 2]
				expect(subject.valid_move?).to eq true
			end

			it "cannot double step if the path is not clear" do
		  	enemy = described_class.new(:white, [2, 1], board)
				board.add_to_cell([2, 1], enemy)
				subject.destination_position = [3, 1]
				expect(subject.valid_move?).to eq false
		  end

			it "cannot double_step if its not the first move" do
				subject.destination_position = [3, 1]
				subject.move!
				subject.destination_position = [5, 1]
				expect(subject.valid_move?).to eq false
			end
			it "cannot move backwards" do
				subject.destination_position = [2, 1]
				subject.move!
				subject.destination_position = [1, 1]
				expect(subject.valid_move?).to eq false
			end
			it "cannot move diagonally if the square is empty" do
				subject.destination_position = [2, 2]
				expect(subject.valid_move?).to eq false
			end
			it "cannot step forward if the squre is occupied" do
				enemy = described_class.new(:black, [2, 1], board)
				board.add_to_cell([2, 1], enemy)
				subject.destination_position = [2, 1]
				expect(subject.valid_move?).to eq false
			end
			context "when enpassant" do
				it "removes the original pawn when attacked" do
					subject.destination_position = [3, 1]
					subject.move!

					enemy = described_class.new(:black, [3, 0], board)
					board.add_to_cell([3, 0], enemy)
					enemy.destination_position = [2, 1]
					enemy.move!
					expect(board[3, 1]).to be_nil
				end
				it "creates a temporary pawn" do
					subject.destination_position = [3, 1]
					subject.move!
					expect(board[2, 1]).to be_a Pawn
				end
				it "dissapears if not attacked in the next move" do
					subject.destination_position = [3, 1]
					subject.move!
					enemy = board[6, 0]
					enemy.destination_position = [5, 0]
					enemy.move!
					expect(board[2, 1]).to be_nil
				end
			end  
			
		end

		context "when black" do
		  subject(:pawn) { board[6, 1] }
		  
		  it "can step" do
		    subject.destination_position = [5, 1]
		    expect(subject.valid_move?).to eq true
		  end
		  
		  it "can double step on the first move" do
		    subject.destination_position = [4, 1]
		    expect(subject.valid_move?).to eq true
		  end
		  
		  it "can attack diagonally left" do
		    enemy = described_class.new(:white, [5, 0], board)
		    board.add_to_cell([5, 0], enemy)
		    subject.destination_position = [5, 0]
		    expect(subject.valid_move?).to eq true
		  end
		  
		  it "can attack diagonally right" do
		    enemy = described_class.new(:white, [5, 2], board)
		    board.add_to_cell([5, 2], enemy)
		    subject.destination_position = [5, 2]
		    expect(subject.valid_move?).to eq true
		  end
		  it "cannot double step if the path is not clear" do
		  	enemy = described_class.new(:black, [5, 1], board)
				board.add_to_cell([5, 1], enemy)
				subject.destination_position = [4, 1]
				expect(subject.valid_move?).to eq false
		  end
		  it "cannot double_step if its not the first move" do
		    subject.destination_position = [4, 1]
		    subject.move!
		    subject.destination_position = [2, 1]
		    expect(subject.valid_move?).to eq false
		  end
		  
		  it "cannot move backwards" do
		    subject.destination_position = [5, 1]
		    subject.move!
		    subject.destination_position = [6, 1]
		    expect(subject.valid_move?).to eq false
		  end
		  
		  it "cannot move diagonally if the square is empty" do
		    subject.destination_position = [5, 2]
		    expect(subject.valid_move?).to eq false
		  end
		  
		  it "cannot step forward if the square is occupied" do
		    enemy = described_class.new(:white, [5, 1], board)
		    board.add_to_cell([5, 1], enemy)
		    subject.destination_position = [5, 1]
		    expect(subject.valid_move?).to eq false
		  end
		  
		  context "when enpassant" do
		  	it "removes the original pawn when attacked" do
					subject.destination_position = [4, 1]
					subject.move!
					enemy = described_class.new(:white, [4, 2], board)
					board.add_to_cell([4, 2], enemy)
					enemy.destination_position = [5, 1]
					enemy.move!
					expect(board[4, 2]).to be_nil
				end
		    it "creates a temporary pawn" do
		      subject.destination_position = [4, 1]
		      subject.move!
		      expect(board[5, 1]).to be_a Pawn
		    end
		    
		    it "disappears if not attacked in the next move" do
		      subject.destination_position = [4, 1]
		      subject.move!
		      enemy = board[1, 0]
		      enemy.destination_position = [2, 0]
		      enemy.move!
		      expect(board[5, 1]).to be_nil
		    end
		  end
	 	end
	end
end
