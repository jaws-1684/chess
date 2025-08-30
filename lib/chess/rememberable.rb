module Chess
	class Rememberable
		def initialize
			@data = Hash.new
		end
		
		def memoize piece, **options
			@data[piece] = options
		end
		def destroy! piece
			@data.delete(piece)
		end
		def dig *options
			@data.dig(*options)
		end
		def [] option
			@data[option]
		end
		def data
			@data
		end
	end
end