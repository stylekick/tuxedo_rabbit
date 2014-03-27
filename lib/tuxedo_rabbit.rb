require "tuxedo_rabbit/version"


module TuxedoRabbit
  autoload :Broker,        'tuxedo_rabbit/broker'
  autoload :Buffer,        'tuxedo_rabbit/buffer'
  autoload :Consumer,        'tuxedo_rabbit/consumer'

  def self.connect(options = {}, config)

    @broker = TuxedoRabbit::Broker.new(config)
    @broker.connect(options)

  end

  def self.publish(*args)
    broker.publish(*args)
  end


  def self.broker
    @broker
  end

end
