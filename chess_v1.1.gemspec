Gem::Specification.new do |s|
  s.name        = "chess"
  s.version     = "1.1.0"
  s.summary     = "Terminal based chess engine written in ruby programming language."
  s.description = File.read(File.join(File.dirname(__FILE__), 'README.md'))
  s.authors     = ["jaws"]
  s.email       = "91t0limxs@mozmail.com"
  s.files       = Dir.glob("{bin,lib,spec}/**/*") + %w(LICENSE README.md)
  s.homepage    = "https://github.com/jaws-1684/chess"
  s.license       = "MIT"
  s.executables   = [ 'chess' ]
  s.required_ruby_version = '>= 3.3.5'
  s.add_dependency "colorize", "~> 1.1"
  s.add_dependency "artii", "~> 2.1"
  s.add_development_dependency 'rspec', '~> 1.1', '>= 1.1.4'
  s.add_development_dependency "pry-byebug", "~> 3.11"
  s.add_development_dependency "rubocop", "~> 1.79"
end