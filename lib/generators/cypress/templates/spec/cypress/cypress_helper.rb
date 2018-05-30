# This is loaded once before the first command is executed

begin
 require 'database_cleaner'
rescue LoadError => e
 puts e.message
end

begin
  require 'factory_bot_rails'
  module FactoryCleaner
    def self.clean(f = FactoryBot)
      f.factories.clear
      f.traits.clear
      f.callbacks.clear
      f.sequences.clear
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


