# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'panda_corps/version'

Gem::Specification.new do |gem|
  gem.authors = ["Ken Romney", "Jayce Higgins"]
  gem.email = ["kromney@instructure.com"]
  gem.description = %q{Instructure Corporate BS comes to code!}
  gem.summary = %q{Corps}
  gem.homepage = 'asdf://coming soon'
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
