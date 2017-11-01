## Unreleased

### Added
* `cy.rails` command for executing raw ruby on the backend
* `cy.setupRails` command for resetting application state
* `cypress:install` generator now adds a `beforeEach` call to `cy.setupRails`
* `cypress:install` generator configures the `cache_classes` setting in `config/environments/test.rb`
* configuration option to include further modules in your runcontext

## 0.1.2 (2017-10-31)
* First release.
