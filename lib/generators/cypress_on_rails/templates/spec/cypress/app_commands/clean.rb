# TODO: this is not covered by unit tests
if defined?(DatabaseCleaner)
  # cleaning the database using database_cleaner
  DatabaseCleaner.strategy = :truncation
  DatabaseCleaner.clean
else
  CypressOnRails.logger.error "[CypressOnRails] add database_cleaner or update clean_db"
  Post.delete_all if defined?(Post)
end

CypressOnRails.logger.info "[CypressOnRails] Database Cleaned" # used by log_fail.rb
