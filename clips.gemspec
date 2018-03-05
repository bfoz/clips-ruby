lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "clips"
  spec.version       = '0'
  spec.authors       = ["Brandon Fosdick"]
  spec.email         = ["bfoz@bfoz.net"]

  spec.summary       = %q{The CLIPS engine reimplemented in Ruby}
  spec.description   = %q{The C Language Integrated Production System (CLIPS), but in Ruby}
  spec.homepage      = "http://github.com/bfoz/clips-ruby"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
