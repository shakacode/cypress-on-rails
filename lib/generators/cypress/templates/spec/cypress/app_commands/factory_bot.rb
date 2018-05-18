# Example of using factory bot
require_relative '../cypress_helper'
begin
  require 'factory_bot_rails'

  Dir["#{__dir__}/../../factories/**/*.rb"].each { |f| require f }

  Array.wrap(command_ptions).each do |factory_options|
    factory_method = factory_options.pop
    FactoryBot.public_send(factory_method, *factory_options)
  end

rescue LoadError
  message = "add factory_bot_rails or update factory_bot"
  puts message
end
