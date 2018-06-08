require 'cypress_dev/configuration'

RSpec.describe CypressDev::Configuration do
  it 'has defaults' do
    CypressDev.configure { |config| config.reset }

    expect(CypressDev.configuration.cypress_folder).to eq('spec/cypress')
    expect(CypressDev.configuration.use_middleware?).to eq(true)
    expect(CypressDev.configuration.logger).to_not be_nil
  end

  it 'can be configured' do
    my_logger = Logger.new(STDOUT)
    CypressDev.configure do |config|
      config.cypress_folder = 'my/path'
      config.use_middleware = false
      config.logger = my_logger
    end
    expect(CypressDev.configuration.cypress_folder).to eq('my/path')
    expect(CypressDev.configuration.use_middleware?).to eq(false)
    expect(CypressDev.configuration.logger).to eq(my_logger)
  end
end
