require 'spec_helper'

class Consuming
  include TuxedoRabbit::Consumer

  consume 'gc.ps.payment.failed'

  def process(msg)
    p 'first message received'
    Hutch.publish('gc.ps.payment.reply', 'test should pass')
  end
end



describe 'consuming', focus: true do
  subject(:consumer){Consuming.new}

  WORKER = nil

  it 'consumes' do


    class ReplyConsumer
      include TuxedoRabbit::Consumer

      consume 'gc.ps.payment.reply'

      def process(msg)
        WORKER.stop
      end
    end

    Hutch.connect
    Hutch.publish('gc.ps.payment.failed', 'content of the message')

    WORKER = Hutch::Worker.new(Hutch.broker, Hutch.consumers)

    WORKER.run
  end
end