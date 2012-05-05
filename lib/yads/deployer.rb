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
        @logger.print(output)
      end
    end

    def method_missing(name, *args)
      if command_names.include?(name.to_s)
        commands = ["cd #{config["path"]}", config["commands"][name.to_s]]
        commands = commands.join(" && ")
        @logger.puts("> #{commands}")
        connection.execute(commands) do |output|
          @logger.print(output)
        end
      else
        super
      end
    end

    def respond_to?(name)
      if command_names.include?(name.to_s)
        true
      else
        super
      end
    end

    def command_names
      config["commands"].keys
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
      @connection ||= begin
        options = {
          :host => config["host"],
          :user => config["user"],
          :forward_agent => config["forward_agent"]
        }
        options[:port] = config["port"] if config["port"]

        SSH.new(options)
      end
    end
  end
end
