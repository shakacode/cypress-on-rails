require_relative '../../lib/cypress/configuration'

RSpec.describe Cypress::Configuration do
  it 'has defaults' do
    Cypress.configure { |config| config.reset }

    expect(Cypress.configuration.cypress_folder).to eq('spec/cypress')
    expect(Cypress.configuration.use_middleware?).to eq(true)
  end

  it 'can be configured' do
    Cypress.configure do |config|
      config.cypress_folder = 'my/path'
      config.use_middleware = false
    end
    expect(Cypress.configuration.cypress_folder).to eq('my/path')
    expect(Cypress.configuration.use_middleware?).to eq(false)
  end
end
