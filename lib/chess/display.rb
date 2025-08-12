module Chess
  class Display
    def initialize(board)
      @board = board
    end

    def render
      puts "\n"
      print_headers
      print_board
      print_headers
      puts "\n"
    end

    def print_headers
      puts "\t\s\s\s\s\sa | b | c | d | e | f | g | h "
    end

   def print_board    
      puts "\t\s\s\s---------------------------------"
    
      @board.grid.reverse.each_with_index do |row, i|
        print_row = row.map do |piece|
          print_piece = piece.nil? ? ' ' : piece.symbol
        end

        puts "\t" + "#{8 - i}\s\s" + "| #{print_row.join(' | ')} |" + "\s\s#{8 - i}"
        puts "\t\s\s\s__________________________________"
      end
    end

  end
end