require 'set'

module TuxedoRabbit
  module Pipe
    def self.included(base) #:nodoc:
      base.extend(ClassMethods)
      base.class_eval do
        include TuxedoRabbit::Subscriber
      end
    end

    module ClassMethods
      def produce(*routing_keys)
        @_produce_routing_keys = self.produce_routing_keys.union(routing_keys)
      end

      def produce_routing_keys
        @_produce_routing_keys ||= Set.new
      end
    end


    def do_it(body)
      raise 'missing implementation of do_it()'
    end

    def process(msg)
      correlation_id = msg.correlation_id
      result = do_it(msg.body)
      if result.respond_to?(:serializeable_hash)
        result = result.serializable_hash
      end

      self.class.produce_routing_keys.each do |key|
        TuxedoRabbit.publish(key, result, {correlation_id: correlation_id})
      end
    end
  end
end