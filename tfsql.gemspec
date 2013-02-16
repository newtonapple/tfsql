# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tfsql/version'

Gem::Specification.new do |gem|
  gem.name          = "tfsql"
  gem.version       = Tfsql::VERSION
  gem.authors       = ["David Dai"]
  gem.email         = ["david.github@gmail.com"]
  gem.description   = "A SQL like language for text files."
  gem.summary       = gem.description
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
