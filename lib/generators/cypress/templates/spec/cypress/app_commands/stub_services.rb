# Example of stubbing external services using rspec
require_relative '../cypress_helper'
begin
  require 'rspec-mocks'
  RSpec::Mocks.teardown
  RSpec::Mocks.setup

  # Add code to stub services here
  # allow(ExternalService).to receive(:retrieve).and_return("result")
rescue LoadError
  message = "add rspec-mocks or update #{__FILE__}"
  Rails.logger.warn message
  puts message
end