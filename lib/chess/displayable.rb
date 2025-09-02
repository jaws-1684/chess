# frozen_string_literal: true

module Chess
  module Displayable
    def self.render(grid)
      puts ''
      headers
      delimiters('+')

      grid.reverse.each_with_index do |row, i|
        stdout_row = row.map do |piece|
          piece.nil? ? "\s" : piece.symbol
        end
        row_index = 8 - i

        delimiters('.') if i != 0
        format_line(stdout_row, row_index)
      end
      delimiters('+')
      headers
      puts ''
    end

    def self.headers
      puts "\t\s\s\s| a | b | c | d | e | f | g | h |".colorize(:light_blue)
    end

    def self.delimiters(symbol)
      puts "\t".ljust(40, "#{symbol}\s").colorize(:gray)
    end

    def self.format_line(stdout_row, row_index)
      index = row_index.to_s.colorize(:light_blue)
      col_delimiter = '|'.center(3, "\s").colorize(:gray)
      data = stdout_row.join(col_delimiter)
      output = [index, data, index].join("\s|\s")
      puts "\t\s#{output}"
    end
  end
end
