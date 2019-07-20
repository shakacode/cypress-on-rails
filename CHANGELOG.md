## [Unreleased]

### Fixed
* fix install generator when using npm [PR 22](https://github.com/shakacode/cypress-on-rails/pull/22) by [josephan](https://github.com/josephan).

### Tasks
* Gemspec: Drop EOL'd property rubyforge_project [PR 27](https://github.com/shakacode/cypress-on-rails/pull/27) by [olleolleolle](https://github.com/olleolleolle)
* Update Travis CI badge in README [PR 31](https://github.com/shakacode/cypress-on-rails/pull/31)
* Fix CI by Installing cypress dependencies on Travis CI [PR 31](https://github.com/shakacode/cypress-on-rails/pull/31)

## [1.4.0] 
* Accept an options argument for scenarios. [PR 18](https://github.com/shakacode/cypress-on-rails/pull/18) by [ericraio](https://github.com/ericraio).

### Changed
* renamed CypressDev to CypressOnRails

## [1.3.0]
### Added
* Send any arguments to simple rails factory, not only hashes by [grantspeelman](https://github.com/grantspeelman).

### Improved
* stop running cypress examples on CI

## [1.2.1]
### Fixed
* simple factory fails silently, changed to use create!

## [1.2.0]
### Tasks
* adding additional log failure logging

## [1.1.1]
### Fixed
* smart factory wrapper can handle when factory files get deleted

## [1.1.0]
### Tasks
* add cypress examples to install generator
* add active record integration specs

## 1.0.1
### Fixed
* install generator adding on-rails.js to import.js

## 1.0.0
* renamed to CypressDev
* middleware stripped down to make it more flexible and generic
* concept of generic commands introduced that can have any ruby in it
* and lots of other changes

## 0.2.2 (2018-03-24)
### Fixed
* fix major bug when using scenarios

## 0.2.1 (2017-11-05)
### Fixed
* fix failure in api tests

## 0.2.0 (2017-11-05)
### Changed
* remove the need for a seperate port for the setup calls. Requires rerunning `cypress:install` generator

## 0.1.5 (2017-11-01)

### Added
* `cy.rails` command for executing raw ruby on the backend
* `cy.setupRails` command for resetting application state
* `cypress:install` generator now adds a `beforeEach` call to `cy.setupRails`
* `cypress:install` generator configures the `cache_classes` setting in `config/environments/test.rb`
* configuration option to include further modules in your runcontext

## 0.1.2 (2017-10-31)
* First release.

[Unreleased]: https://github.com/shakacode/cypress-on-rails/compare/v1.4.0...master
[1.4.0]: https://github.com/shakacode/cypress-on-rails/compare/v1.3.0...v1.4.0
[1.3.0]: https://github.com/shakacode/cypress-on-rails/compare/v1.2.1...v1.3.0
[1.2.1]: https://github.com/shakacode/cypress-on-rails/compare/v1.2.0...v1.2.1
[1.2.0]: https://github.com/shakacode/cypress-on-rails/compare/v1.1.1...v1.2.0
[1.1.1]: https://github.com/shakacode/cypress-on-rails/compare/v1.1.0...v1.1.1
[1.1.0]: https://github.com/shakacode/cypress-on-rails/compare/v1.0.0...v1.1.0
