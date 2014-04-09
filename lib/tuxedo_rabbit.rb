require 'hutch'
require 'hutch/message'
require_relative 'tuxedo_rabbit/config'


module Hutch
  class Message

    def correlation_id
      @properties[:correlation_id]
    end

    attr_reader :properties

    def to_s
      attrs = { :@body => body.to_s, message_id: message_id,
                timestamp: timestamp, routing_key: routing_key, correlation_id: correlation_id }
      "#<Message #{attrs.map { |k,v| "#{k}=#{v.inspect}" }.join(', ')}>"
    end

  end
end


module TuxedoRabbit
  autoload :Config,        'tuxedo_rabbit/config'
  autoload :Broker,        'tuxedo_rabbit/broker'
  autoload :Buffer,        'tuxedo_rabbit/buffer'
  autoload :Subscriber,    'tuxedo_rabbit/subscriber'
  autoload :Message,       'tuxedo_rabbit/message'
  autoload :CLI,           'tuxedo_rabbit/cli'
  autoload :Version,       'tuxedo_rabbit/version'
  autoload :Pipe,          'tuxedo_rabbit/pipe'



  def self.connect(options = {:enable_http_api_use => false}, config)
    @broker = TuxedoRabbit::Broker.new(config)
    @broker.connect(options)

  end

  def self.publish(*args)
    broker.publish(*args)
  end


  def self.broker
    @broker
  end



  class Runner

    def initialize
      @cli = Hutch::CLI.new
    end

    def run
      @cli.run
    end
  end
end
