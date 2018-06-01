# This is loaded once before the first command is executed

begin
 require 'database_cleaner'
rescue LoadError => e
 puts e.message
end

begin
  require 'factory_bot_rails'
rescue LoadError => e
  puts e.message
  begin
    require 'factory_girl_rails'
  rescue LoadError => e
    puts e.message
  end
end

require 'cypress/smart_factory_wrapper'

factory = Cypress::SimpleRailsFactory
factory = FactoryBot if defined?(FactoryBot)
factory = FactoryGirl if defined?(FactoryGirl)

Cypress::SmartFactoryWrapper.configure(
    factory: factory,
    files: Dir["./spec/factories/**/*.rb"]
)

begin
  require 'rspec-mocks'
rescue LoadError => e
  puts e.message
end


