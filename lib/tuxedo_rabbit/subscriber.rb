module TuxedoRabbit
  Subscriber = Hutch::Consumer

  module Subscriber

    module ClassMethods
      alias_method :hutch_get_queue_name, :get_queue_name

      def get_queue_name
        "#{app_name}:#{hutch_get_queue_name}"
      end

      def app_name
        "#{Rails.application.class.parent_name}".downcase
      end
    end
  end
end







