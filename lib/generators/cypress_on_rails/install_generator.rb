module CypressOnRails
  class InstallGenerator < Rails::Generators::Base
    class_option :cypress_folder, type: :string, default: 'spec/cypress'
    class_option :install_cypress_with, type: :string, default: 'yarn'
    class_option :install_cypress_examples, type: :boolean, default: true
    source_root File.expand_path('../templates', __FILE__)

    def install_cypress
      if !Dir.exists?(options.cypress_folder) || Dir["#{options.cypress_folder}/*"].empty?
        directories = options.cypress_folder.split('/')
        directories.pop
        install_dir = "#{Dir.pwd}/#{directories.join('/')}"
        command = nil
        if options.install_cypress_with == 'yarn'
          command = "yarn --cwd=#{install_dir} add cypress --dev --silent"
        elsif options.install_cypress_with == 'npm'
          command = "cd #{install_dir}; npm install cypress --save-dev --silent"
        end
        if command
          say command
          fail 'failed to install cypress' unless system(command)
        end
        if options.install_cypress_examples
          directory 'spec/cypress/integration/examples', "#{options.cypress_folder}/integration/examples"
          directory 'spec/cypress/fixtures', "#{options.cypress_folder}/fixtures"
        end
        copy_file "spec/cypress/support/index.js", "#{options.cypress_folder}/support/index.js"
        copy_file "spec/cypress/support/commands.js", "#{options.cypress_folder}/support/commands.js"
        copy_file "spec/cypress.json", "#{options.cypress_folder}/../cypress.json"
      end
    end

    def add_initial_files
      generate "cypress_on_rails:update", "--cypress_folder=#{options.cypress_folder}"
      directory 'spec/cypress/integration/rails_examples', "#{options.cypress_folder}/integration/rails_examples"
    end

    def update_files
      append_to_file "#{options.cypress_folder}/support/index.js",
                     "\nimport './on-rails'",
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
