require "net/ssh"
require "yaml"

module Ployml

  class ConfigNotFound < Errno::ENOENT; end

  class Deployer
    def initialize(logger = STDOUT)
      @logger = logger
    end

    def deploy
      begin
        config = YAML.load(File.open("config/deploy.yml"))
      rescue Errno::ENOENT
        raise Ployml::ConfigNotFound, "config/deploy.yml not found"
      end

      Net::SSH.start(config["host"], config["user"], :forward_agent => config["forward_agent"]) do |ssh|
        check_path(ssh, config["path"], config["commands"].delete("clone"))

        commands = config["commands"].values.unshift("cd #{config['path']}").join(" && ")
        @logger.puts "> #{commands}"
        @logger.puts

        ssh.exec(commands) do |ch, stream, data|
          print data
        end

        ssh.loop
      end
    end

    def check_path(ssh, path, clone)
      @logger.puts "> cd #{path}/.git"
      ssh.exec("cd #{path}/.git") do |ch, stream, data|
        if stream == :stderr
          @logger.puts "> cd #{path}"
          ssh.exec("cd #{path}") do |ch1, stream1, data1|
            @logger.puts "> #{clone}"
            ssh.exec(clone) do |ch1, stream1, data1|
              abort data1 if stream1 == :stderr

              @logger.puts "> cd #{path}"
              ssh.exec("cd #{path}")
            end
          end
        end
      end
      ssh.loop
    end
  end
end
