module CypressOnRails
  class InstallGenerator < Rails::Generators::Base
    class_option :api_prefix, type: :string, default: ''
    class_option :install_folder, type: :string, default: 'e2e'
    class_option :install_cypress, type: :boolean, default: true
    class_option :install_playwright, type: :boolean, default: false
    class_option :install_with, type: :string, default: 'yarn'
    class_option :cypress_folder, type: :string, default: 'cypress'
    class_option :playwright_folder, type: :string, default: 'playwright'
    class_option :experimental, type: :boolean, default: false
    source_root File.expand_path('../templates', __FILE__)

    def install_framework
      directories = options.install_folder.split('/')
      directories.pop
      install_dir = "#{Dir.pwd}/#{directories.join('/')}"

      command = nil
      packages = []

      packages << 'cypress' if options.install_cypress
      packages.push('playwright', '@playwright/test') if options.install_playwright

      if options.install_with == 'yarn'
        command = "yarn --cwd=#{install_dir} add #{packages.join(' ')} --dev"
      elsif options.install_with == 'npm'
        command = "cd #{install_dir}; npm install #{packages.join(' ')} --save-dev"
      end
      if command
        say command
        fail "failed to install #{packages.join(' ')}" unless system(command)
      end

      if options.install_cypress
        template "spec/cypress/support/index.js.erb", "#{options.cypress_folder}/support/index.js"
        copy_file "spec/cypress/support/commands.js", "#{options.cypress_folder}/support/commands.js"
        copy_file "spec/cypress.config.js", "#{options.cypress_folder}/../cypress.config.js"
      end
      if options.install_playwright
        template "spec/playwright/support/index.js.erb", "#{options.playwright_folder}/support/index.js"
        copy_file "spec/playwright.config.js", "#{options.playwright_folder}/../playwright.config.js"
      end
    end

    def add_initial_files
      template "config/initializers/cypress_on_rails.rb.erb", "config/initializers/cypress_on_rails.rb"
      template "spec/e2e/e2e_helper.rb.erb", "#{options.install_folder}/e2e_helper.rb"
      directory 'spec/e2e/app_commands', "#{options.install_folder}/app_commands"
      if options.install_cypress
        copy_file "spec/cypress/support/on-rails.js", "#{options.cypress_folder}/support/on-rails.js"
        directory 'spec/cypress/e2e/rails_examples', "#{options.cypress_folder}/e2e/rails_examples"
      end
      if options.install_playwright
        copy_file "spec/playwright/support/on-rails.js", "#{options.playwright_folder}/support/on-rails.js"
        directory 'spec/playwright/e2e/rails_examples', "#{options.playwright_folder}/e2e/rails_examples"
      end
    end

    def update_files
      append_to_file "#{options.cypress_folder}/support/index.js",
                     "\nimport './on-rails'",
                     after: 'import \'./commands\''
      append_to_file "#{options.playwright_folder}/support/index.js",
                     "\nimport './on-rails'",
                     after: '// Import commands.js using ES2015 syntax:'
    end
  end
end
