require 'hutch/config'

module TuxedoRabbit
  module Config

  end
end

module Hutch
  module Config
    def self.initialize
      @config = {
          mq_host: 'localhost',
          mq_port: 5672,
          mq_exchange: 'tuxedo',  # TODO: should this be required?
          mq_vhost: '/',
          mq_tls: false,
          mq_tls_cert: nil,
          mq_tls_key: nil,
          mq_username: 'guest',
          mq_password: 'guest',
          mq_api_host: 'localhost',
          mq_api_port: 15672,
          mq_api_ssl: false,
          log_level: Logger::INFO,
          require_paths: [],
          autoload_rails: true,
          error_handlers: [Hutch::ErrorHandlers::Logger.new],
          namespace: nil,
          channel_prefetch: 0
      }
    end
  end



end