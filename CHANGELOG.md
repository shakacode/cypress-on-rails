## [1.16.0]
[Compare]: https://github.com/shakacode/cypress-on-rails/compare/v1.15.1...v1.16.0

### Added
* Add support for `before_request` options on the middleware, for authentication [PR 138](https://github.com/shakacode/cypress-on-rails/pull/138) by [RomainEndelin]

## [1.15.1]
[Compare]: https://github.com/shakacode/cypress-on-rails/compare/v1.15.0...v1.15.1

### Fixed
* fix cypress_folder deprecation warning by internal code [PR 136](https://github.com/shakacode/cypress-on-rails/pull/136)

## [1.15.0]
[Compare]: https://github.com/shakacode/cypress-on-rails/compare/v1.14.0...v1.15.0

### Changed
* Add support for any e2e testing framewrok starting with Playwright [PR 131](https://github.com/shakacode/cypress-on-rails/pull/131) by [KhaledEmaraDev]

## [1.14.0]
[Compare]: https://github.com/shakacode/cypress-on-rails/compare/v1.13.1...v1.14.0

### Changed
* Add support for proxy routes through `api_prefix` [PR 130](https://github.com/shakacode/cypress-on-rails/pull/130) by [RomainEndelin]

### Fixed
* Properly copies the cypress_helper file when running the update generator [PR 117](https://github.com/shakacode/cypress-on-rails/pull/117) by [alvincrespo]

### Tasks
* pass cypress record key to github action [PR 110](https://github.com/shakacode/cypress-on-rails/pull/110)

## [1.13.1]
[Compare]: https://github.com/shakacode/cypress-on-rails/compare/v1.13.0...v1.13.1

### Fixed
* use_vcr_middleware disabled by default [PR 109](https://github.com/shakacode/cypress-on-rails/pull/109)

## [1.13.0]
[Compare]: https://github.com/shakacode/cypress-on-rails/compare/v1.12.1...v1.13.0

### Changed
* Add support for matching npm package and VCR
* generate for cypress 10 [PR 108](https://github.com/shakacode/cypress-on-rails/pull/108)

## [1.12.1]
[Compare]: https://github.com/shakacode/cypress-on-rails/compare/v1.12.0...v1.12.1

### Tasks
* Documenting how to setup Factory Associations [PR 100](https://github.com/shakacode/cypress-on-rails/pull/100)

### Fixed
* keep track of factory manual reloads to prevent auto_reload from reloading again [PR 98](https://github.com/shakacode/cypress-on-rails/pull/98)

## [1.12.0]
[Compare]: https://github.com/shakacode/cypress-on-rails/compare/v1.11.0...v1.12.0

### Changed
* only reload factories on clean instead of every factory create request [PR 95](https://github.com/shakacode/cypress-on-rails/pull/95)
* alternative command added for get tail of logs [PR 89](https://github.com/shakacode/cypress-on-rails/pull/89) by [ccrockett]

### Tasks
* switch from travis to github actions [PR 96]

## [1.11.0]
[Compare]: https://github.com/shakacode/cypress-on-rails/compare/v1.10.1...v1.11.0

### Changed
* improve app command logging on cypress
* Allow build and build_list commands to be executed against factory bot [PR 87](https://github.com/shakacode/cypress-on-rails/pull/87) by [Alexander-Blair]

## [1.10.1]
[Compare]: https://github.com/shakacode/cypress-on-rails/compare/v1.9.1...v1.10.1

### Changed
* improve error message received from failed command

## [1.9.1]
[Compare]: https://github.com/shakacode/cypress-on-rails/compare/v1.9.0...v1.9.1

### Fixed
* fix using `load` in command files

## [1.9.0]
[Compare]: https://github.com/shakacode/cypress-on-rails/compare/v1.8.1...v1.9.0

### Changed
* Update default generated folder to cypress instead of spec/cypress
* Add a generator option to not install cypress
* generator by default does not include examples
* default on local to run cypress in development mode

## [1.8.1]
[Compare]: https://github.com/shakacode/cypress-on-rails/compare/v1.8.0...v1.8.1

### Fixed
* remove "--silent" option when adding cypress [PR 76](https://github.com/shakacode/cypress-on-rails/pull/76)
* update cypress examples to use "preserve" instead of "whitelist" [PR 75](https://github.com/shakacode/cypress-on-rails/pull/75) by [alvincrespo](https://github.com/alvincrespo)

## [1.8.0]
[Compare]: https://github.com/shakacode/cypress-on-rails/compare/v1.7.0...v1.8.0

### Changed
* Use `FactoryBo#reload` to reset factory bot

## [1.7.0]
[Compare]: https://github.com/shakacode/cypress-on-rails/compare/v1.6.0...v1.7.0

### Changed
*  Improve eval() in command executor [PR 46](https://github.com/shakacode/cypress-on-rails/pull/46) by [Systho](https://github.com/Systho)

### Fixed
* Add middleware after load_config_initializers [PR 62](https://github.com/shakacode/cypress-on-rails/pull/62) by [duytd](https://github.com/duytd)

## [1.6.0]
[Compare]: https://github.com/shakacode/cypress-on-rails/compare/v1.5.1...v1.6.0

### Changed
* Change default port to 5017 [PR 49](https://github.com/shakacode/cypress-on-rails/pull/49) by [vfonic](https://github/vfonic)

### Fixed
* fix file location warning message in clean.rb [PR 54](https://github.com/shakacode/cypress-on-rails/pull/54) by [ootoovak](https://github.com/ootoovak)

## [1.5.1]
[Compare]: https://github.com/shakacode/cypress-on-rails/compare/v1.5.0...v1.5.1

### Fixed
* fix FactoryBot Trait not registered error [PR 43](https://github.com/shakacode/cypress-on-rails/pull/43)

## [1.5.0]
[Compare]: https://github.com/shakacode/cypress-on-rails/compare/v1.4.2...v1.5.0

### Added
* Serialize and return responses to be used in tests [PR 34](https://github.com/shakacode/cypress-on-rails/pull/34).
* Update generator to make it easier to update core generated files [PR 35](https://github.com/shakacode/cypress-on-rails/pull/35).

### Tasks
* Update integration tests [PR 36](https://github.com/shakacode/cypress-on-rails/pull/36).

## [1.4.2]
[Compare]: https://github.com/shakacode/cypress-on-rails/compare/v1.4.1...v1.4.2

### Fixed
* update generator to use full paths for Factory files [PR 33](https://github.com/shakacode/cypress-on-rails/pull/33).

## [1.4.1]
[Compare]: https://github.com/shakacode/cypress-on-rails/compare/v1.4.0...v1.4.1

### Fixed
* fix install generator when using npm [PR 22](https://github.com/shakacode/cypress-on-rails/pull/22) by [josephan](https://github.com/josephan).

### Tasks
* Fix typo in authentication docs [PR 29](https://github.com/shakacode/cypress-on-rails/pull/27) by [badimalex](https://github.com/badimalex)
* Gemspec: Drop EOL'd property rubyforge_project [PR 27](https://github.com/shakacode/cypress-on-rails/pull/27) by [olleolleolle](https://github.com/olleolleolle)
* Update Travis CI badge in README [PR 31](https://github.com/shakacode/cypress-on-rails/pull/31)
* Fix CI by Installing cypress dependencies on Travis CI [PR 31](https://github.com/shakacode/cypress-on-rails/pull/31)

## [1.4.0]
[Compare]: https://github.com/shakacode/cypress-on-rails/compare/v1.3.0...v1.4.0

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

[1.8.0]: https://github.com/shakacode/cypress-on-rails/compare/v1.7.0...v1.8.0
[1.7.0]: https://github.com/shakacode/cypress-on-rails/compare/v1.6.0...v1.7.0
[1.6.0]: https://github.com/shakacode/cypress-on-rails/compare/v1.5.1...v1.6.0
[1.5.1]: https://github.com/shakacode/cypress-on-rails/compare/v1.5.0...v1.5.1
[1.5.0]: https://github.com/shakacode/cypress-on-rails/compare/v1.4.2...v1.5.0
[1.4.2]: https://github.com/shakacode/cypress-on-rails/compare/v1.4.1...v1.4.2
[1.4.1]: https://github.com/shakacode/cypress-on-rails/compare/v1.4.0...v1.4.1
[1.4.0]: https://github.com/shakacode/cypress-on-rails/compare/v1.3.0...v1.4.0
[1.3.0]: https://github.com/shakacode/cypress-on-rails/compare/v1.2.1...v1.3.0
[1.2.1]: https://github.com/shakacode/cypress-on-rails/compare/v1.2.0...v1.2.1
[1.2.0]: https://github.com/shakacode/cypress-on-rails/compare/v1.1.1...v1.2.0
[1.1.1]: https://github.com/shakacode/cypress-on-rails/compare/v1.1.0...v1.1.1
[1.1.0]: https://github.com/shakacode/cypress-on-rails/compare/v1.0.0...v1.1.0
