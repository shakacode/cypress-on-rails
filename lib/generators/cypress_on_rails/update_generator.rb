module CypressOnRails
  class UpdateGenerator < Rails::Generators::Base
    class_option :cypress_folder, type: :string, default: 'spec/cypress'
    source_root File.expand_path('../templates', __FILE__)

    def update_generated_files
      template "config/initializers/cypress_on_rails.rb.erb", "config/initializers/cypress_on_rails.rb"
      copy_file "spec/cypress/cypress_helper.rb", "#{options.cypress_folder}/cypress_helper.rb"
      copy_file "spec/cypress/support/on-rails.js", "#{options.cypress_folder}/support/on-rails.js"
      directory 'spec/cypress/app_commands', "#{options.cypress_folder}/app_commands"
    end
  end
end
