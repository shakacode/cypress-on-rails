# Example of stubbing external services using rspec
if defined?(RSpec::Mocks)
  RSpec::Mocks.teardown
  RSpec::Mocks.setup
else
  logger.warn "add rspec-mocks or update stub_services"
end

