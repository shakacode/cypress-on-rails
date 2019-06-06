require 'active_support/core_ext/string'

module CypressOnRails
  module SimpleRailsFactory
    def self.create(type, *params)
      params = [{}] if params.empty?
      type.camelize.constantize.create!(*params)
    end

    def self.create_list(type, amount, *params)
      amount.to_i.times do
        create(type,*params)
      end
    end
  end
end
