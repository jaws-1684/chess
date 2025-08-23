module Chess
	class Rememberable
		def initialize
			@data = {
			"white_king" => { position: [0, 4] },
			"black_king" => { position: [7, 4] },
			}
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
	end
end
