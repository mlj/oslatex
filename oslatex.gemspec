# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'oslatex/version'

Gem::Specification.new do |spec|
  spec.name          = "oslatex"
  spec.version       = OSLaTeX::VERSION
  spec.authors       = ["Marius L. Jøhndal"]
  spec.email         = ["mariuslj@ifi.uio.no"]
  spec.summary       = %q{Word-to-LaTeX style converter}
  spec.description   = %q{A converter for Word documents that maps Word styles to LaTeX command and environments}
  spec.homepage      = "https://github.com/mlj/oslatex"
  spec.license       = "MIT"

  spec.files         = Dir["{bin,lib}/**/*"] + %w(README.md LICENSE)
  spec.executables   = %w(oslatex)
  spec.require_paths = ["lib"]

  spec.add_dependency 'nokogiri', '~> 1.6'
  spec.add_dependency 'rubyzip', '~> 1.1'
  spec.add_dependency 'colorize', '~> 0.7'

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'pry', '~> 0.10'
end
