require 'spec_helper'

describe TuxedoRabbit do
  describe '.connect' do
    context 'not connected' do
      let(:options) { double 'options' }
      let(:config)  { double 'config' }
      let(:broker)  { instance_double 'TuxedoRabbit::Broker' }
      let(:action)  { TuxedoRabbit.connect(options, config) }

      it 'passes options and config' do
        expect(TuxedoRabbit::Broker).to receive(:new).with(config).and_return(broker)
        expect(broker).to receive(:connect).with(options)

        action
      end
      #
      #it 'sets @connect' do
      #  action
      #
      #  expect(Hutch.connected?).to be_true
      #end
    end

    context 'connected' do
      #before { Hutch.stub(:connected?).and_return true }
      #
      #it 'does not reconnect' do
      #  Hutch::Broker.should_not_receive :new
      #  Hutch.connect
      #end
    end
  end

  describe '#publish' do
    let(:broker) { instance_double('TuxedoRabbit::Broker') }
    let(:args) { ['test.key', 'message', { headers: { foo: 'bar' } }] }

    before do
      TuxedoRabbit.stub broker: broker
    end

    it 'delegates to TuxedoRabbit::Broker#publish' do
      expect(broker).to receive(:publish).with(*args)
      TuxedoRabbit.publish(*args)
    end
  end
end