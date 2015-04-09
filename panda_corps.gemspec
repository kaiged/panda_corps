# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'panda_corps/version'

Gem::Specification.new do |gem|
  gem.authors = ["Ken Romney", "Jayce Higgins"]
  gem.email = ["kromney@instructure.com"]
  gem.description = %q{Just do your work; we'll handle the rest.}
  gem.summary = %q{PandaCorps}
  gem.homepage = 'https://github.com/kaiged/panda_corps'
  gem.license = 'coming soon'

  gem.files = %w[panda_corps.gemspec]
  gem.files += Dir.glob("lib/**/*.rb")
  gem.files += Dir.glob("spec/**/*")
  gem.test_files = Dir.glob("spec/**/*")
  gem.name = "panda_corps"
  gem.require_paths = ["lib"]
  gem.version = PandaCorps::VERSION

  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'byebug'
end
