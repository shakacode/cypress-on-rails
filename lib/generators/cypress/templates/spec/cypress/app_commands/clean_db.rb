# Example of cleaning the database using database_cleaner
require_relative '../cypress_helper'
begin
  require 'database_cleaner'
  DatabaseCleaner.strategy = :truncation
  DatabaseCleaner.clean
rescue LoadError
  message = "add database_cleaner or update #{__FILE__}"
  Rails.logger.warn message
  puts message
end