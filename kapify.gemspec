# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kapify/version'

Gem::Specification.new do |gem|
  gem.name          = "kapify"
  gem.version       = Kapify::VERSION
  gem.authors       = ["Ivan Tkalin"]
  gem.email         = ["itkalin@gmail.com"]
  gem.description   = %q{Capistrano recipes useful for rails app deployment. Includes repices for nginx, unicorn, postgres, logrotate, resque}
  gem.summary       = %q{Capistrano recipes useful for rails app deployment}
  gem.homepage      = "https://github.com/ivalkeen/kapify"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'capistrano', '>= 2.0'
  gem.add_development_dependency "rake"
end
