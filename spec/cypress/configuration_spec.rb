require_relative '../../lib/cypress/configuration'

RSpec.describe Cypress::Configuration do
  it 'has defaults' do
    expect(Cypress.configuration.cypress_folder).to eq('spec/cypress')
  end

  it 'can be configured' do
    Cypress.configure do |config|
      config.cypress_folder = 'my/path'
    end
    expect(Cypress.configuration.cypress_folder).to eq('my/path')
  end
end
