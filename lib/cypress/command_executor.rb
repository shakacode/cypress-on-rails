module Cypress
  # Middleware to handle cypress commands and eval
  class CommandExecutor
    def self.load(file,command_options = nil)
      file_data = File.read(file)
      eval file_data
    end
  end
end
