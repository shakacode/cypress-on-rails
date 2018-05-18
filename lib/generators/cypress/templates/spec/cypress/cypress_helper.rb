# This is loaded once before the first command is executed

begin
 require 'database_cleaner'
rescue LoadError => e
 puts e.message
end

begin
  require 'factory_bot_rails'
  Dir["./spec/factories/**/*.rb"].each { |f| require f }
rescue LoadError => e
  puts e.message
end

begin
  require 'rspec-mocks'
rescue LoadError => e
  puts e.message
end


