module Cypress
  # Middleware to handle cypress commands and eval
  class CommandExecutor
    def self.load(file,command_options = nil)
      file_data = File.read(file)
      eval file_data
    rescue => e
      logger.error("fail to execute #{file}: #{e.message}")
      raise e
    end

    def self.logger
      Cypress.configuration.logger
    end
  end
end
