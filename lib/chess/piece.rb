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
    def enemy
      board.grid[dx][dy]
    end
    def assign_symbol
      raise NotImplementedError, "Subclasses must implement the assign_symbol method"
    end
    def valid_move?
      raise "Destination position is missing!" unless destination_position
    end
    def move!
      raise "Not a valid #{self.name} move!" unless valid_move?
    end
    def attack!
      raise "Not a valid #{self.name} attack!" unless valid_attack?
    end
    private
      def basic_action
        yield if block_given? 
        @last_position = @current_position
        @current_position = destination_position
        board.update_board(last_position, current_position)
        @destination_position = nil    
      end
  end
end
require_relative "pieces/bishop"
require_relative "pieces/king"
require_relative "pieces/knight"
require_relative "pieces/pawn"
require_relative "pieces/queen"
require_relative "pieces/rook"
require_relative "validator"
