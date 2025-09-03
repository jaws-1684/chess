module Chess
  module Db
    module Save
      def save_file!(filename, data)
        filename = "chess_#{Time.now.strftime('%Y%m%d')}.dat" if filename.empty?
        begin
          # Ensure directory exists
          path_to_file = File.expand_path("../../../bin/#{filename}", File.dirname(__FILE__))
          File.open(path_to_file, 'wb') do |file|
            # Marshal.dump the entire game state
            file.write(Marshal.dump(data))
          end
          puts "Game saved successfully as #{filename}."
          true
        rescue StandardError => e
          puts e.message
          puts 'Error while saving game.'
          false
        end
      end
    end
  end
end
