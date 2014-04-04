module TuxedoRabbit
  require 'hutch'
  require 'redis'
  require 'multi_json'


  class Broker

    attr_accessor :redis, :hutch_broker, :buffer

    def initialize(config = nil)
      @config = config || Hutch::Config
    end

    def connect(options={})
      setup_redis_connection
      setup_amqp_connection
      drain_buffer
    end

    def publish(*args)
      begin
        unless @buffer.empty?
          drain_buffer
        end
        @hutch_broker.publish(*args)
      rescue Hutch::PublishError => e
        buffer.publish(*args)
      end
    end

    def setup_redis_connection
      @redis = $redis || Redis.new()
      @buffer = TuxedoRabbit::Buffer.new(@redis)
    end

    def drain_buffer
      @buffer.drain.each do |msg|
        publish(msg['routing_key'], msg['message'], msg['properties'])
      end
    end

    def disconnect
      @redis.quit if @redis
      @redis = nil
      @hutch_broker.disconnect if @hutch_broker
      @hutch_broker = nil
    end

    def exchange
      @hutch_broker.exchange
    end

    def setup_amqp_connection
      Hutch.connect({:enable_http_api_use => false}, @config)
      @hutch_broker = Hutch.broker
    end

    def amqp_connection
      @hutch_broker.connection
    end

    def amqp_connected?
      Hutch.connected?
    end
  end
end