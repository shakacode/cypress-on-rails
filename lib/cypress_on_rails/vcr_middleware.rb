require 'json'
require 'rack'
require 'cypress_on_rails/middleware_config'

module CypressOnRails
  # Middleware to handle vcr
  class VCRMiddleware
    include MiddlewareConfig

    def initialize(app, vcr = nil)
      @app = app
      @vcr = vcr
      @first_call = false
    end

    def call(env)
      request = Rack::Request.new(env)
      if request.path.start_with?('/__cypress__/vcr/insert')
        configuration.tagged_logged { handle_insert(request) }
      elsif request.path.start_with?('/__cypress__/vcr/eject')
        configuration.tagged_logged { handle_eject }
      else
        do_first_call unless @first_call
        @app.call(env)
      end
    end

    private

    def handle_insert(req)
      WebMock.enable! if defined?(WebMock)
      vcr.turn_on!
      body = JSON.parse(req.body.read)
      logger.info "vcr insert cassette: #{body}"
      cassette_name = body[0]
      options = (body[1] || {}).symbolize_keys
      options[:record] = options[:record].to_sym if options[:record]
      options[:match_requests_on] = options[:match_requests_on].map(&:to_sym) if options[:match_requests_on]
      options[:serialize_with] = options[:serialize_with].to_sym if options[:serialize_with]
      options[:persist_with] = options[:persist_with].to_sym if options[:persist_with]
      vcr.insert_cassette(cassette_name, options)
      [201, {'Content-Type' => 'application/json'}, [{'message': 'OK'}.to_json]]
    rescue LoadError, ArgumentError => e
      [501, {'Content-Type' => 'application/json'}, [{'message': e.message}.to_json]]
    end

    def handle_eject
      logger.info "vcr eject cassette"
      vcr.eject_cassette
      do_first_call
      [201, {'Content-Type' => 'application/json'}, [{'message': 'OK'}.to_json]]
    rescue LoadError, ArgumentError => e
      [501, {'Content-Type' => 'application/json'}, [{'message': e.message}.to_json]]
    end

    def vcr
      return @vcr if @vcr
      require 'vcr'
      VCR.configure do |config|
        config.cassette_library_dir = "#{configuration.cypress_folder}/fixtures/vcr_cassettes"
      end
      @vcr = VCR
    end

    def do_first_call
      @first_call = true
      vcr.turn_off!
      WebMock.disable! if defined?(WebMock)
    rescue LoadError
      # nop
    end
  end
end
