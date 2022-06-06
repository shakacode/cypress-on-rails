module CypressOnRails
  class InstallGenerator < Rails::Generators::Base
    class_option :cypress_folder, type: :string, default: 'cypress'
    class_option :install_cypress, type: :boolean, default: true
    class_option :install_cypress_with, type: :string, default: 'yarn'
    class_option :experimental, type: :boolean, default: false
    source_root File.expand_path('../templates', __FILE__)

    def install_cypress
      directories = options.cypress_folder.split('/')
      directories.pop
      install_dir = "#{Dir.pwd}/#{directories.join('/')}"
      command = nil
      if options.install_cypress
        if options.install_cypress_with == 'yarn'
          command = "yarn --cwd=#{install_dir} add cypress --dev"
        elsif options.install_cypress_with == 'npm'
          command = "cd #{install_dir}; npm install cypress --save-dev"
        end
        if command
          say command
          fail 'failed to install cypress' unless system(command)
        end
      end
      template "spec/cypress/support/index.js.erb", "#{options.cypress_folder}/support/index.js"
      copy_file "spec/cypress/support/commands.js", "#{options.cypress_folder}/support/commands.js"
      copy_file "spec/cypress.config.js", "#{options.cypress_folder}/../cypress.config.js"
    end

    def add_initial_files
      template "config/initializers/cypress_on_rails.rb.erb", "config/initializers/cypress_on_rails.rb"
      template "spec/cypress/cypress_helper.rb.erb", "#{options.cypress_folder}/cypress_helper.rb"
      copy_file "spec/cypress/support/on-rails.js", "#{options.cypress_folder}/support/on-rails.js"
      directory 'spec/cypress/app_commands', "#{options.cypress_folder}/app_commands"
      directory 'spec/cypress/e2e/rails_examples', "#{options.cypress_folder}/e2e/rails_examples"
    end

    def update_files
      append_to_file "#{options.cypress_folder}/support/index.js",
                     "\nimport './on-rails'",
                     after: 'import \'./commands\''
    end
  end
end
