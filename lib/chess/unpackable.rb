module Chess
	module Unpackable
		def unpack position
      px, py = position
      yield(px, py) if block_given?
    end
	end
end