module Fluent
  class LeftronicOutput < Fluent::BufferedOutput
    Fluent::Plugin.register_output('leftronic', self)

    config_param :access_key
    config_param :stream_name
    config_param :value, :default => nil
    config_param :graph_type, :default => "line"
    config_param :display_keys, :default => nil
    config_param :name_key_pattern, :default => nil

    def initialize
      Encoding.default_internal = "UTF-8"
      require 'uri'
      require 'json'
      require 'leftronic'
      super
    end

    def configure(conf)
      super
      if @access_key.nil? || @access_key.empty?
        raise ConfigError, "leftronic configure requires 'access_key'"
      end

      if @stream_name.nil? || @stream_name.empty?
        raise ConfigError, "leftronic configure requires 'stream_name'"
      end

      if @graph_type == 'number' or @graph_type == 'line'
        if @value.nil? || @value.size == 0
          raise ConfigError, "leftronic configure requires 'value'"
        end
      end
      
      unless @display_keys.nil?
        @default_key = false
        @leftronic_display_hash = eval(@display_keys)
        $log.info @leftronic_display_hash
      else 
        @default_key = true
      end
      @leftronic = Leftronic.new @access_key
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
      chunk.msgpack_each do |tag, time, record|
        next if record.nil? || record.empty?
        if @graph_type == 'number' or @graph_type == 'line'
          next unless record.has_key? @value
          @leftronic.number(@stream_name ,record[@value].to_i)
        elsif @graph_type == 'leaderboard' or @graph_type == 'bar' or @graph_type == 'pie'
          result = Hash.new
          record.each {|key,value|
            unless name_key_pattern.nil?
              next if key !~ /#{@name_key_pattern}/
            end

            unless @default_key
              display_key = @leftronic_display_hash.has_key?(key) ? @leftronic_display_hash[key] : key
            else
              display_key = key
            end
            result[display_key] = value.to_i
          }
          $log.info result
          @leftronic.leaderboard(@stream_name,[result])
        end
      end
    end
  end
end
