require_relative "actionable"
require_relative "unpackable"

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
    attr_reader :color, :current_position, :last_position, :board, :symbol
    attr_accessor :destination_position

    def initialize color, current_position, board
      @color = color
      @symbol = assign_symbol
      @current_position = current_position
      @board = board
    end

    def move!
      raise "Destination position is missing!" unless destination_position
      raise "Not a valid #{self.name} move!" unless valid_move?
      raise "Path is not clear!" unless board.path_clear?(current_position, destination_position)
      raise "You cannot move over your own #{piece.name}!" if piece&.friendly?(self)
      raise "You cannot place you own king into check!" unless safe_move?

      puts "Moving to #{destination_position}."
    end
    def valid_move?
      valid_moves.include?(destination_position)
    end
    def safe_move?
      safe_moves.include?(destination_position)
    end
    def friendly? other_piece
      other_piece&.color == self.color
    end
    def enemy? other_piece
      other_piece&.color != self.color
    end
    def piece square=destination_position
      unpack(square) { |dx, dy| board[dx, dy] }
    end
    def enemy
      piece if piece&.enemy?(self)
    end
    def can_attack? square
      valid_moves.include?(square)
    end
    def any_safe_moves?
      safe_moves.empty? ? false : true
    end

    def basic_move board=self.board, &block
      yield if block_given? 

      @last_position = @current_position
      @current_position = destination_position
      board.captured_pieces << enemy if !!enemy
      board.update!(self, last_position, current_position)
      @destination_position = nil
    end

    private
      include Coordinates
      include Unpackable

      def assign_symbol
        raise NotImplementedError, "Subclasses must implement the assign_symbol method"
      end
      def cloned_board &block
        yield(board.dup) if block_given?
      end
      def valid_moves
        possible_moves.reject { |position| !board.valid_position?(position) }.select(&valid) 
      end
      def safe_moves
        valid_moves.each_with_object([]) do |position, a|
          cloned_board do |board|
            piece = self.clone
            piece.destination_position = position
            piece.basic_move(board)
            a << position unless board.in_check?
          end
        end
      end
      def valid
        proc { |position| !piece(position)&.friendly?(self) && board.path_clear?(self.current_position, position) }
      end
  end
end

require_relative "pieces/bishop"
require_relative "pieces/king"
require_relative "pieces/knight"
require_relative "pieces/pawn"
require_relative "pieces/queen"
require_relative "pieces/rook"
