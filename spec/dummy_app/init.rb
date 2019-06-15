require 'action_controller/railtie'
require 'action_view/railtie'
require 'sprockets/railtie'

module Dummy
  class Application < ::Rails::Application
    config.root = __dir__
    config.active_support.deprecation = :stderr
    config.cache_store = :memory_store
    config.consider_all_requests_local = true
    config.eager_load = false
    config.assets.digest = false

    config.assets.configure do |env|
      env.cache = ActiveSupport::Cache.lookup_store(:memory_store)
    end
  end
end
