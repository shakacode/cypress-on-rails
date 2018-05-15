module Cypress
  class InstallGenerator < Rails::Generators::Base
    class_option :cypress_folder, type: :string, default: 'spec/cypress'
    source_root File.expand_path('../templates', __FILE__)

    def add_initial_files
      template "config/initializers/cypress_on_rails.rb.erb", "config/initializers/cypress_on_rails.rb"
      copy_file "spec/cypress/cypress_helper.rb", "#{options.cypress_folder}/cypress_helper.rb"
      copy_file "spec/cypress/integration/simple_spec.js", "#{options.cypress_folder}/integration/simple_spec.js"
      copy_file "spec/cypress/support/on-rails.js", "#{options.cypress_folder}/support/on-rails.js"
      copy_file "spec/cypress/app_commands/scenarios/basic.rb", "#{options.cypress_folder}/app_commands/scenarios/basic.rb"
      copy_file "spec/cypress/app_commands/clean_db.rb", "#{options.cypress_folder}/app_commands/clean_db.rb"
      copy_file "spec/cypress.json", "#{options.cypress_folder}/../cypress.json"
    end

    def update_files
      append_to_file "#{options.cypress_folder}/support/index.js",
                     'require(\'./on-rails\')'
    end

    def update_test_rb
      if File.exist?('config/environments/test.rb')
        gsub_file 'config/environments/test.rb',
                  'config.cache_classes = true',
                  'config.cache_classes = ENV[\'CI\'].present?'
      end
      if File.exist?('spec/dummy/config/environments/test.rb')
        gsub_file 'spec/dummy/config/environments/test.rb',
                  'config.cache_classes = true',
                  'config.cache_classes = ENV[\'CI\'].present?'
      end
    end
  end
end
