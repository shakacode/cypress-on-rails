# Example of using factory bot
if defined?(FactoryBot)
  Array.wrap(command_options).each do |factory_options|
    factory_method = factory_options.shift
    FactoryBot.public_send(factory_method, *factory_options)
  end
else
  logger.warn 'add factory_bot_rails or update factory_bot'
end
