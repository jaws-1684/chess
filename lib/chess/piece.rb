module Chess
  module Coordinates
     #grab current position x and y
    def px
      @current_position[0]
    end
    def py
      @current_position[1]
    end
    #grab destinaton position x and y
    def dx
      @destination_position[0]
    end
    def dy
      @destination_position[1]
    end
  end
  
  class Piece
    include Coordinates
    include Validator::Path
    attr_reader :color, :current_position, :last_position
    attr_accessor :destination_position, :board, :symbol

    def initialize color, current_position
      @color = color
      @symbol = assign_symbol
      @current_position = current_position
    end
  
    def friendly? other_piece
      other_piece.color == self.color
    end
    def enemy? other_piece
      other_piece.color != self.color
    end
    def enemy
      piece = board[dx, dy]
      raise "You cannot attack your own #{piece.name}!" if piece&.friendly?(self)
      piece
    end
    def assign_symbol
      raise NotImplementedError, "Subclasses must implement the assign_symbol method"
    end
    def move!
      raise "Destination position is missing!" unless destination_position
      raise "Not a valid #{self.name} move!" unless valid_move?
      raise "Path is not clear!" unless path_clear?
    end
    private
      def basic_move &block
        puts "Moving to #{destination_position}."
        yield if block_given? 

        @last_position = @current_position
        @current_position = destination_position
        board.captured_pieces << enemy if !!enemy
        board.update!(self, last_position, current_position)
        @destination_position = nil    
      end
  end
end
require "ostruct"
require_relative "pieces/bishop"
require_relative "pieces/king"
require_relative "pieces/knight"
require_relative "pieces/pawn"
require_relative "pieces/queen"
require_relative "pieces/rook"
require_relative "validator"
