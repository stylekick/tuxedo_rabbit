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
      @redis = $redis || connect_to_redis
      @buffer = TuxedoRabbit::Buffer.new(@redis)
    end

    def connect_to_redis
      if ENV['REDIS_URL']
        Redis.new(:url => ENV['REDIS_URL'])
      else
        Redis.new()
      end
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


require 'hutch/broker'

module Hutch
  class Broker
    def open_connection!
      host     = @config[:mq_host]
      port     = @config[:mq_port]
      vhost    = @config[:mq_vhost]
      username = @config[:mq_username]
      password = @config[:mq_password]
      tls      = @config[:mq_tls]
      tls_key  = @config[:mq_tls_cert]
      tls_cert = @config[:mq_tls_key]
      protocol = tls ? "amqps://" : "amqp://"
      sanitized_uri = "#{protocol}#{username}@#{host}:#{port}/#{vhost.sub(/^\//, '')}"



      if ENV['RABBITMQ_URL']
        @connection = Bunny.new(ENV['RABBITMQ_URL'])
        sanitized_uri = ENV['RABBITMQ_URL']
      else
        @connection = Bunny.new(host: host, port: port, vhost: vhost,
                                tls: tls, tls_key: tls_key, tls_cert: tls_cert,
                                username: username, password: password,
                                heartbeat: 30, automatically_recover: true,
                                network_recovery_interval: 1)
      end
      logger.info "connecting to rabbitmq (#{sanitized_uri})"

      with_bunny_connection_handler(sanitized_uri) do
        @connection.start
      end

      @connection
    end

    def bindings
      {}
    end
  end
end