require 'multi_json'

class TuxedoRabbit::Buffer
  def initialize(redis)
    @redis = redis
  end

  def publish(routing_key, message, properties = {})
    @redis.rpush key, MultiJson.dump({routing_key: routing_key, message: message, properties: properties})
  end



  def drain
    drained_messages = []
    messages = @redis.lrange key, 0, length
    messages.each do |msg|
      drained_messages << MultiJson.load(msg)
        #@exchange.publish hash.fetch('message'), hash.fetch('options')
    end
    clear_buffer
    drained_messages
  end

  def empty?
    length == 0
  end

  def length
    @redis.llen(key)
  end

  def clear_buffer
    @redis.del key
  end

  def key
    'failed-messages'
  end

end