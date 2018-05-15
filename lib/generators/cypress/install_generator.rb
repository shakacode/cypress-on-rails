module Cypress
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    def add_initial_files
      copy_file "spec/cypress/cypress_helper.rb"
      copy_file "spec/cypress/integrations/simple_spec.js"
      copy_file "spec/cypress/integrations/simple_spec.js"
      copy_file "spec/cypress/support/setup.js"
    end

    def update_test_rb
      replace = [
          "# when running the cypress UI, allow reloading of classes",
          "  config.cache_classes = (defined?(Cypress) ? Cypress.configuration.cache_classes : true)"
      ]
      gsub_file 'config/environments/test.rb', 'config.cache_classes = true', replace.join("\n")
    end
  end
end