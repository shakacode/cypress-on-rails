module Cypress
  class Railtie < Rails::Railtie
    generators do
      require_relative '../generators/install_generator'
    end
  end
end
