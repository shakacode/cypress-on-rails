require_relative '../../lib/cypress/railtie'

module Rails
  def self.env
  end
end

RSpec.describe Cypress::Railtie do
  let(:rails_env) { double }
  let(:middleware) { double('Middleware', use: true) }
  let(:rails_app) { double('RailsApp', middleware: middleware) }

  before do
    allow(Rails).to receive(:env).and_return(rails_env)
  end

  it 'runs the middleware in test mode' do
    Cypress::Railtie.initializers.each do |initializer|
      initializer.run(rails_app)
    end
  end
end
