# Example of cleaning the database using database_cleaner
if defined?(DatabaseCleaner)
  DatabaseCleaner.strategy = :truncation
  DatabaseCleaner.clean
else
  logger.warn "add database_cleaner or update clean_db"
end