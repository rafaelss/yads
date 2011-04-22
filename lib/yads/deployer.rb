require "yaml"

module Yads
  class Deployer

    def initialize(logger = STDOUT)
      @logger = logger
    end

    def setup
      command = "mkdir -p #{config["path"]} && cd #{config["path"]} && git clone --depth 1 #{config['repository']} ."
      @logger.puts("> #{command}")
      @logger.puts(connection.execute(command))
    end

    def deploy
      commands = config["commands"].values
      commands.unshift("cd #{config["path"]}")
      commands = commands.join(" && ")

      @logger.puts("> #{commands}")
      connection.execute(commands) do |output|
        @logger.puts(output)
      end
    end

    private

      def config
        @config ||= begin
          YAML.load(File.open("config/deploy.yml"))
        rescue Errno::ENOENT
          raise Yads::ConfigNotFound, "config/deploy.yml not found"
        end
      end

      def connection
        @connection ||= SSH.new(:host => config["host"], :user => config["user"], :forward_agent => config["forward_agent"])
      end
  end
end
