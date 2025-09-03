module Chess
  module Coordinates
    # grab current position x and y
    def px
      @current_position[0]
    end

    def py
      @current_position[1]
    end

    # grab destinaton position x and y
    def dx
      @destination_position[0]
    end

    def dy
      @destination_position[1]
    end
  end
end
