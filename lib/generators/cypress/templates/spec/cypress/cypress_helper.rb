ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../../config/environment', __FILE__)

Cypress.configure do |c|
  # change this to nil, if you are not using RSpec Mocks
  c.test_framework = :rspec

  # change this to nil, if you are not using DatabaseCleaner
  c.db_resetter = :database_cleaner

  c.before do
    # this is called when you call cy.setupScenario
    # use it to reset your application state
  end

  # add a module to your run context
  # c.include MyModule
end