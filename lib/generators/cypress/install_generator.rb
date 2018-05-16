module Cypress
  class InstallGenerator < Rails::Generators::Base
    class_option :cypress_folder, type: :string, default: 'spec/cypress'
    source_root File.expand_path('../templates', __FILE__)

    def install_cypress
      if !Dir.exists?(options.cypress_folder) || Dir["#{options.cypress_folder}/*"].empty?
        directories = options.cypress_folder.split('/')
        directories.pop
        install_dir = directories.join('/')
        yarn_command = "yarn --cwd=#{install_dir} add cypress --dev"
        say yarn_command
        unless system(yarn_command)
          fail 'failed to install cypress'
        end
      end
    end

    def add_initial_files
      template "config/initializers/cypress_on_rails.rb.erb", "config/initializers/cypress_on_rails.rb"
      copy_file "spec/cypress/cypress_helper.rb", "#{options.cypress_folder}/cypress_helper.rb"
      copy_file "spec/cypress/integration/on_rails_spec.js", "#{options.cypress_folder}/integration/on_rails_spec.js"
      copy_file "spec/cypress/support/index.js", "#{options.cypress_folder}/support/index.js"
      copy_file "spec/cypress/support/commands.js", "#{options.cypress_folder}/support/commands.js"
      copy_file "spec/cypress/support/on-rails.js", "#{options.cypress_folder}/support/on-rails.js"
      copy_file "spec/cypress/app_commands/scenarios/basic.rb", "#{options.cypress_folder}/app_commands/scenarios/basic.rb"
      copy_file "spec/cypress/app_commands/clean_db.rb", "#{options.cypress_folder}/app_commands/clean_db.rb"
      copy_file "spec/cypress/app_commands/stub_services.rb", "#{options.cypress_folder}/app_commands/stub_services.rb"
      copy_file "spec/cypress.json", "#{options.cypress_folder}/../cypress.json"
    end

    def update_files
      append_to_file "#{options.cypress_folder}/support/index.js",
                     'import \'./on-rails\'',
                     after: 'import \'./commands\''
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
