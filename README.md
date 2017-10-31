# cypress-on-rails

Proof-of-Concept gem for using [cypress.io](http://github.com/cypress-io/) in Rails applications. It provides the following features:
* scenarios to setup database before test run
* database cleaning before test run (using database_cleaner)
* ability to use RSpec Mocks for your Rails code

## Getting started

Add this to your Gemfile:
```
group :test do
  gem 'cypress-on-rails'
end
```

The generate the boilerplate code using:
```
rails g cypress:install
```

Finally add the `cypress` package using yarn:
```
yarn add --dev cypress
```

If you are not using RSpec and/or database_cleaner look at `spec/cypress/cypress_helper.rb`.

## Usage

This gem provides the `cypress` command. When called without any arguments ie. `bundle exec cypress`, it will start the cypress.io UI. While running the UI you can edit both your application and test code and see the effects on the next test run. When run as `bundle exec cypress run` it runs headless for CI testing.

The generator adds the following files/directory to your application:
* `spec/cypress/cypress_helper.rb` contains your configuration
* `spec/cypress/integrations/` contains your tests
* `spec/cypress/scenarios/` contains your scenario definitions
* `spec/cypress/support/setup.js` contains support code

### Using scenarios

When writing End-to-End tests, you will probably want to prepare your database to a known state. Maybe using a gem like factory_girl. This gem introduces the concept of a scenario for this purpose. Think of it as a named `before` block in RSpec.

You define a scenario in the `spec/cypress/scenarios` directory:
```
# spec/cypress/scenarios/basic.rb
scenario :basic do
  Profile.create name: "Cypress Hill"
end
```

Then reference the scenario in your test:
```
// spec/cypress/integrations/simple_spec.js
describe('My First Test', function() {
  it('visit root', function() {
    // This calls to the backend to prepare the application state
    cy.setupScenario('basic')

    // The application unter test is available at SERVER_PORT
    cy.visit('http://localhost:'+Cypress.env("SERVER_PORT"))

    cy.contains("Cypress Hill")
  })
})
```

The `setupScenario` call does the following things:
* clears the database using database_cleaner (can be disabled)
* calls the scenario block associated with the name given
* calls the optional `before` block from `spec/cypress/cypress_helper.rb`

# Limitations
This code is very much at the proof-of-concept stage. The following limitations are known:
* It requires yarn for the javascript dependency management
* Only tested on Rails 5.1
* Only works with RSpec and database_cleaner
