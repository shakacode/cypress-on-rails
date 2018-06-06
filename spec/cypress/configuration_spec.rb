require_relative '../../lib/cypress/configuration'

RSpec.describe Cypress::Configuration do
  it 'has defaults' do
    Cypress.configure { |config| config.reset }

    expect(Cypress.configuration.cypress_folder).to eq('spec/cypress')
    expect(Cypress.configuration.use_middleware?).to eq(true)
    expect(Cypress.configuration.logger).to_not be_nil
  end

  it 'can be configured' do
    my_logger = Logger.new(STDOUT)
    Cypress.configure do |config|
      config.cypress_folder = 'my/path'
      config.use_middleware = false
      config.logger = my_logger
    end
    expect(Cypress.configuration.cypress_folder).to eq('my/path')
    expect(Cypress.configuration.use_middleware?).to eq(false)
    expect(Cypress.configuration.logger).to eq(my_logger)
  end
end
