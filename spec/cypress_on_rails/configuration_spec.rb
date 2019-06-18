require 'cypress_on_rails/configuration'

RSpec.describe CypressOnRails::Configuration do
  it 'has defaults' do
    CypressOnRails.configure { |config| config.reset }

    expect(CypressOnRails.configuration.cypress_folder).to eq('spec/cypress')
    expect(CypressOnRails.configuration.use_middleware?).to eq(true)
    expect(CypressOnRails.configuration.logger).to_not be_nil
  end

  it 'can be configured' do
    my_logger = Logger.new(STDOUT)
    CypressOnRails.configure do |config|
      config.cypress_folder = 'my/path'
      config.use_middleware = false
      config.logger = my_logger
    end
    expect(CypressOnRails.configuration.cypress_folder).to eq('my/path')
    expect(CypressOnRails.configuration.use_middleware?).to eq(false)
    expect(CypressOnRails.configuration.logger).to eq(my_logger)
  end
end
