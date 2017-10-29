module Cypress
  class CallbackServer
    attr_reader :port
    def initialize(owner)
      @port    = 9293
      @webrick = WEBrick::HTTPServer.new(:Port => port)
      @webrick.mount_proc '/' do |req, res|
        owner.run_command JSON.parse(req.body)
        res.body = ''
      end
    end

    def start
      @webrick.start
    end

    def shutdown
      @webrick.shutdown
    end

    def callback_url
      "http://localhost:9293"
    end
  end
end
