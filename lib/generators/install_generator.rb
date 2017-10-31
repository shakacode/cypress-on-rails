module Cypress
  class InstallGenerator < Rails::Generators::Base
    def install
      empty_directory "spec/cypress"
      empty_directory "spec/cypress/integrations"
      empty_directory "spec/cypress/scenarios"
      empty_directory "spec/cypress/support"

      create_file "spec/cypress/cypress_helper.rb", <<-FILE
Cypress.configure do |c|
  # change this to nil, if you are not using RSpec Mocks
  c.test_framework = :rspec

  # change this to nil, if you are not using DatabaseCleaner
  c.db_resetter = :database_cleaner

  c.before do
    # this is called when you call cy.setupScenario
    # use it to reset your application state
  end
end
FILE

    create_file "spec/cypress/integrations/simple_spec.js", <<-FILE
describe('My First Test', function() {
  it('visit root', function() {
    // This calls to the backend to prepare the application state
    // see the scenarios directory
    cy.setupScenario('basic')

    // The application unter test is available at SERVER_PORT
    cy.visit('http://localhost:'+Cypress.env("SERVER_PORT"))
  })
})
FILE

    create_file "spec/cypress/scenarios/basic.rb", <<-FILE
scenario :basic do
  # You can setup your Rails state here
  # MyModel.create name: 'something'
end
FILE

    create_file "spec/cypress/integrations/simple_spec.js", <<-FILE
// dont remove this command
Cypress.Commands.add('setupScenario', function(name) {
  Cypress.log({ message: name })
  cy.request('POST', Cypress.env("CALLBACK"), JSON.stringify({ scenario: name }))
});
FILE
  end
end