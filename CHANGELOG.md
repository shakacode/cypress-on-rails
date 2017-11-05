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
