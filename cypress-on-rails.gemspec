# -*- encoding: utf-8 -*-
$LOAD_PATH.push File.expand_path("../lib", __FILE__)
require "cypress_dev/version"

Gem::Specification.new do |s|
  s.name        = "cypress-on-rails"
  s.version     = CypressDev::VERSION
  s.author      = ["miceportal team", 'Grant Petersen-Speelman']
  s.email       = ["info@miceportal.de", 'grantspeelman@gmail.com']
  s.homepage    = "http://github.com/grantspeelman/cypress-on-rails"
  s.summary     = "Deprecated in favor of the 'cypress_on_rails' gem."
  s.description = "Deprecated in favor of the 'cypress_on_rails' gem."
  s.post_install_message = <<EOM
  +---------------------------------------------------------------------------+
  |                                                                           |
  |  NOTICE: cypress-on-rails is deprecated in the favor of cypress_on_rails  |
  |                                                                           |
  |  Please update to use the 'cypress_on_rails' gem instead.                 |
  |  See: https://github.com/shakacode/cypress_on_rails                       |
  |                                                                           |
  +---------------------------------------------------------------------------+
EOM
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
