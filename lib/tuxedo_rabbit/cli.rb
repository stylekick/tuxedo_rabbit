module TuxedoRabbit
  class CLI
    def initialize
      @cli = Hutch::CLI.new
    end

    def run
      @cli.run
    end
  end
end