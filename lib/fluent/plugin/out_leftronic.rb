module Fluent
  class LeftronicOutput < Fluent::BufferedOutput
    Fluent::Plugin.register_output('leftronic', self)

    config_param :access_key
    config_param :stream_name
    config_param :value, :default => nil
    config_param :graph_type, :default => "line"

    def initialize
      require 'net/https'
      require 'uri'
      require 'json'

      super
    end

    def configure(conf)
      super

      if @value.nil? || @value.size == 0
        raise ConfigError, "leftronic_out requires 'value'"
      end

      @uri = URI.parse("https://www.leftronic.com/customSend/")

      @https = Net::HTTP.new(@uri.host, @uri.port)
      @https.use_ssl = true
    end

    def start
      super
    end

    def shutdown
      super
    end

    def format(tag, time, record)
      [tag, time, record].to_msgpack
    end

    def write(chunk)
      data = []
      chunk.msgpack_each do |tag, time, record|
        if @graph_type == 'line'
          data << {timestamp: time, number: record[@value].to_i}
        end
      end
      post(accessKey: @access_key, streamName: @stream_name, point: data) if data.length > 0
    end

    def post(data)
      req = Net::HTTP::Post.new(@uri.request_uri)
      req.content_type = 'application/json'
      req.body = data.to_json

      @https.request(req)
    end
  end
end