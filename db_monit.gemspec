# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'db_monit/version'

Gem::Specification.new do |spec|
  spec.name          = "db_monit"
  spec.version       = DbMonit::VERSION
  spec.authors       = ["renehernandez"]
  spec.email         = ["renehr9102@gmail.com"]

  spec.summary       = "DbMonit aims to ease how to monitor database servers"
  spec.homepage      = "https://github.com/renehernandez/db_monit.git"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against " \
  #     "public gem pushes."
  # end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = ["db_monit"]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"

  spec.add_dependency "mysql2", "~> 0.4.5"
  spec.add_dependency "thor", "~> 0.19"
end
