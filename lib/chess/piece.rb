require_relative "actionable"

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
    attr_reader :color, :current_position, :last_position, :board, :symbol, :score
    attr_accessor :destination_position

    def initialize color, current_position, board
      @color = color
      @symbol = assign_symbol
      @current_position = current_position
      @board = board
    end

    def move!
      raise "Destination position is missing!" unless destination_position
      raise "You cannot move over your own #{piece.name}!" if piece&.friendly?(self)
      raise "Path is not clear!" unless board.path_clear?(current_position, destination_position)
      raise "Not a valid #{self.name} move!" unless valid_move?
      raise "You cannot place you own king into check!" unless safe_move?
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
      board.select_square(square)
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
    def valid_moves &block
      valid_moves = possible_moves.reject { |position| !board.valid_position?(position) }.select(&valid)
      valid_moves.select! { |pmove| yield(pmove) } if block_given?
      valid_moves
    end
    def safe_moves &block
      valid_moves.each_with_object([]) do |position, a|
        cloned_board do |board|
          piece = board.select_square(self.current_position)
          piece.destination_position = position
          piece.basic_move(board)
          board.set_squares_under_attack!
      
          a << position unless board.in_check?
          #the block is needed for the computer object to select safe_squares fo any given pieces no just the king 
          yield(board, position) if block_given? 
        end
      end
    end
    def <=> other
      #sorting from lowest to highest
      self.score <=> other.score
    end
    def > other
      self.score > other.score
    end

    private
      include Coordinates

      def assign_symbol
        raise NotImplementedError, "Subclasses must implement the assign_symbol method"
      end
      def cloned_board &block
        yield(board.dup) if block_given?
      end
      
      def valid
        proc { |position| position != current_position && !piece(position)&.friendly?(self) && board.path_clear?(self.current_position, position) }
      end
  end
end
