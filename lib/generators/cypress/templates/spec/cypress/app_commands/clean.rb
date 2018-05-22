if defined?(DatabaseCleaner)
  # cleaning the database using database_cleaner
  DatabaseCleaner.strategy = :truncation
  DatabaseCleaner.clean
else
  logger.warn "add database_cleaner or update clean_db"
end

if defined?(FactoryBot)
  # resetting all factories
  FactoryBot.reset
  Dir["./spec/factories/**/*.rb"].each { |f| load f }
else
  logger.warn "add factory_bot or update clean_db"
end
