# -*- encoding: utf-8 -*-
$LOAD_PATH.push File.expand_path("../lib", __FILE__)
require "cypress_dev/version"

Gem::Specification.new do |s|
  s.name        = "cypress-on-rails"
  s.version     = CypressDev::VERSION
  s.licenses    = ['MIT']
  s.author      = ["miceportal team", 'Grant Petersen-Speelman']
  s.email       = ["info@miceportal.de", 'grantspeelman@gmail.com']
  s.homepage    = "http://github.com/grantspeelman/cypress-on-rails"
  s.summary     = "Integrates cypress with rails or rack applications"
  s.description = "Integrates cypress with rails or rack applications"
  s.rubyforge_project = s.name
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {spec}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.add_dependency 'rack'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'railties', '>= 3.2'
end
