require 'spec_helper'

describe TuxedoRabbit::Broker do
  let(:config) { deep_copy(Hutch::Config.user_config) }

  subject(:broker) { TuxedoRabbit::Broker.new(config) }

  describe '#connect' do
    #before { broker.stub(:set_up_amqp_connection) }
    #before { broker.stub(:set_up_api_connection) }
    #before { broker.stub(:disconnect) }

    it 'sets up the Hutch and Redis connection' do
      expect(Hutch).to receive(:connect)
      expect(broker).to receive(:setup_redis_connection)
      expect(broker).to receive(:drain_buffer)

      broker.connect
    end
  end

  describe '#setup_redis_connection' do
    before { broker.setup_redis_connection }
    after  { broker.disconnect }

    its(:redis) { should be_a Redis }
    its(:buffer) { should be_a TuxedoRabbit::Buffer}
  end

  describe '#setup_amqp_connection' do
    before { broker.setup_amqp_connection }
    after  { broker.disconnect }

    its(:amqp_connection) { should be_a Bunny::Session }
  end


  describe '#publish' do
    context 'with a valid connection' do
      before(:all) { broker.connect }
      after(:all)  { broker.disconnect }

      xit 'publishes to the exchange' do
        broker.hutch_broker.exchange.should_receive(:publish).once
        broker.publish('test.key', 'message')
      end

      xit 'sets default properties' do
        broker.hutch_broker.exchange.should_receive(:publish).with(
            JSON.dump("message"),
            hash_including(
                persistent: true,
                routing_key: 'test.key',
                content_type: 'application/json'
            )
        )

        broker.publish('test.key', 'message')
      end

      xit 'allows passing message properties' do
        broker.hutch_broker.exchange.should_receive(:publish).once
        broker.publish('test.key', 'message', {expiration: "2000", persistent: false})
      end

      #context 'when there are global properties' do
      #  context 'as a hash' do
      #    before do
      #      Hutch.stub global_properties: { app_id: 'app' }
      #    end
      #
      #    it 'merges the properties' do
      #      broker.exchange.should_receive(:publish).with('"message"', hash_including(app_id: 'app'))
      #      broker.publish('test.key', 'message')
      #    end
      #  end
      #
      #  context 'as a callable object' do
      #    before do
      #      Hutch.stub global_properties: proc { { app_id: 'app' } }
      #    end
      #
      #    it 'calls the proc and merges the properties' do
      #      broker.exchange.should_receive(:publish).with('"message"', hash_including(app_id: 'app'))
      #      broker.publish('test.key', 'message')
      #    end
      #  end
      #end
    end
    #
    context 'without a valid connection' do
      before { broker.connect }
      after { broker.disconnect }

      it 'writes to redis' do
        broker.hutch_broker.stub(:publish){raise Hutch::PublishError}

        expect(broker.buffer).to receive(:publish)

        broker.publish('test.key', 'message')
      end


      #it 'logs an error' do
      #  broker.logger.should_receive(:error)
      #  broker.publish('test.key', 'message') rescue nil
      #end
    end
  end

  describe 'buffer recovery' do
    context 'when the redis buffer is not empty' do
      before(:each) do
        broker.connect
        broker.hutch_broker.disconnect
        #p broker
        broker.publish('test.key', 'message')
        #before(:all) { broker.connect }
      end


      after(:each)  { broker.disconnect }

      it 'drains the buffer on publish' do
        #broker.setup_amqp_connection
        broker.hutch_broker.connect
        broker.publish('test.key', 'second message')
      end

      #it 'drains the buffer on reconnection'

    end
  end

end