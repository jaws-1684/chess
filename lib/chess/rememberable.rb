# frozen_string_literal: true

module Chess
  class Rememberable
    def initialize
      @data = {}
    end

    def memoize piece, **options
      @data[piece] = options
    end

    def destroy!(piece)
      @data.delete(piece)
    end

    def dig *options
      @data.dig(*options)
    end

    def [](option)
      @data[option]
    end

    attr_reader :data
  end
end
