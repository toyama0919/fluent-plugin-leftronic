# coding: utf-8
module Fluent
  class LeftronicOutput < Fluent::BufferedOutput
    Fluent::Plugin.register_output('leftronic', self)

    config_param :access_key
    config_param :stream_name
    config_param :value, default: nil
    config_param :graph_type, default: 'line'
    config_param :display_keys, default: nil
    config_param :name_key_pattern, default: nil

    def initialize
      require 'leftronic'
      super
    end

    def configure(conf)
      super
      if @access_key.nil? || @access_key.empty?
        fail ConfigError, "leftronic configure requires 'access_key'"
      end

      if @stream_name.nil? || @stream_name.empty?
        fail ConfigError, "leftronic configure requires 'stream_name'"
      end

      if @graph_type == 'number' || @graph_type == 'line'
        if @value.nil? || @value.size == 0
          fail ConfigError, "leftronic configure requires 'value'"
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
        if @graph_type == 'number' || @graph_type == 'line'
          next unless record.key? @value
          @leftronic.number(@stream_name , record[@value].to_i)
        elsif @graph_type == 'leaderboard' || @graph_type == 'bar' || @graph_type == 'pie'
          result = Hash.new
          record.each do|key, value|
            unless name_key_pattern.nil?
              next if key !~ /#{@name_key_pattern}/
            end

            unless @default_key
              display_key = @leftronic_display_hash.key?(key) ? @leftronic_display_hash[key] : key
            else
              display_key = key
            end
            result[display_key] = value.to_i
          end
          $log.info result
          @leftronic.leaderboard(@stream_name, [result])
        end
      end
    end
  end
end
