module Chess
	module Actionable
		 module Promotion
    def final_row?
      px == (color == :black ? 0 : 7)
    end

    def promoting_pieces
      [
        Chess::Pieces::Queen.new(color, [px, py], board),
        Chess::Pieces::Bishop.new(color, [px, py], board),
        Chess::Pieces::Knight.new(color, [px, py], board),
        Chess::Pieces::Rook.new(color, [px, py], board)
      ]
    end

    def promote!
      puts "Select a piece you want (Q/B/K/R):\s".colorize(:green)
      choice = gets.chomp.downcase.to_sym
      piece = case choice
              when :q then promoting_pieces[0]
              when :b then promoting_pieces[1]
              when :k then promoting_pieces[2]
              when :r then promoting_pieces[3]
              else promoting_pieces[0]
              end
      board.update!(piece, last_position, current_position)
    end

    def auto_promote!
      piece = promoting_pieces.sample
      board.update!(piece, last_position, current_position)
    end
  end
	end
end