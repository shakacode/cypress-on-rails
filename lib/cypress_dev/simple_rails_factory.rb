module CypressDev
  module SimpleRailsFactory
    def self.create(type, params = {})
      type.camelize.constantize.create(params)
    rescue NameError => e
      Rails.logger.warn e.message
    end

    def self.create_list(type, amount, params = {})
      amount.to_i.times do
        create(type,params)
      end
    rescue NameError => e
      Rails.logger.warn e.message
    end
  end
end
