module TuxedoRabbit
  Consumer = Hutch::Consumer

  module Consumer

    module ClassMethods
      alias_method :hutch_get_queue_name, :get_queue_name

      def get_queue_name
        p 'get queue name'
        p "#{app_name}:#{hutch_get_queue_name}"
        "#{app_name}:#{hutch_get_queue_name}"
      end

      def app_name
        'Stylekick'.downcase
      end
    end
  end


end







