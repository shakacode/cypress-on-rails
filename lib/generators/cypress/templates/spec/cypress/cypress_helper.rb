# This is loaded once before the first command is executed

begin
 require 'database_cleaner'
rescue LoadError => e
 puts e.message
end

begin
  require 'factory_bot_rails'
  module FactoryBot
    def self.reset
      factories.clear
      traits.clear
      callbacks.clear
      sequences.clear
    end
  end
rescue LoadError => e
  puts e.message
end

begin
  require 'rspec-mocks'
rescue LoadError => e
  puts e.message
end


