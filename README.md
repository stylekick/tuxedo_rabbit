# TuxedoRabbit

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'tuxedo_rabbit', github: 'stylekick/tuxedo_rabbit'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tuxedo_rabbit

## Usage

Ensure RabbitMQ and Redis are running

### Initializer

    require 'tuxedo_rabbit'
    require 'hutch'
    
    TuxedoRabbit.connect(Hutch::Config)

### Worker

    bundle exec tuxedo

### Publishing

    class ProductUrl < ActiveRecord::Base
        
        after_create do |record|
            TuxedoRabbit.publish('product_url.created', {url: record.url}, {correlation_id: record.url})
        end

### Subscribing

Subscriber classes must define the exchange ir reads from and a process method that receives a message object

    class UpdatedProduct
      include TuxedoRabbit::Subscriber
      
      consume 'product.updated'
    
      def process(msg)
        # do some useful work
      end
    end


### Piping with Correlation

Piping classes must define the routing key to read from and to publish to. The do_it method receives a method body and must return a json serializable object.

    class CreatedProductUrl
      include TuxedoRabbit::Pipe
    
      consume 'product_url.created'
      produce 'product.scraped'
    
      def do_it(body)
        # do some useful work and return a json serializable object
      end
    end

## Contributing

1. Fork it ( http://github.com/<my-github-username>/tuxedo_rabbit/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
