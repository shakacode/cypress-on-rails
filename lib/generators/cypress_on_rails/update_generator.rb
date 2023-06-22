module CypressOnRails
  class UpdateGenerator < Rails::Generators::Base
    class_option :install_folder, type: :string, default: 'spec/e2e'
    class_option :install_cypress, type: :boolean, default: true
    class_option :install_playwright, type: :boolean, default: false
    class_option :install_with, type: :string, default: 'yarn'
    class_option :cypress_folder, type: :string, default: 'spec/cypress'
    class_option :playwright_folder, type: :string, default: 'spec/playwright'
    source_root File.expand_path('../templates', __FILE__)

    def update_generated_files
      template "config/initializers/cypress_on_rails.rb.erb", "config/initializers/cypress_on_rails.rb"
      template "spec/e2e/e2e_helper.rb.erb", "#{options.install_folder}/e2e_helper.rb"
      directory 'spec/e2e/app_commands', "#{options.install_folder}/app_commands"

      if options.install_cypress
        copy_file "spec/cypress/support/on-rails.js", "#{options.cypress_folder}/support/on-rails.js"
      end
      if options.install_playwright
        copy_file "spec/playwright/support/on-rails.js", "#{options.playwright_folder}/support/on-rails.js"
      end
    end
  end
end
