require "net/ssh"

module Yads

  class SSH

    def initialize(config)
      options = { :forward_agent => config[:forward_agent] }
      options[:port] = config[:port] if config[:port]

      @ssh = Net::SSH.start(config[:host], config[:user], options)
    end

    def execute(cmd)
      if block_given?
        @ssh.exec(cmd) do |ch, stream, data|
          yield data
        end
        @ssh.loop
      else
        @ssh.exec!(cmd)
      end
    end

    def close
      @ssh.close
    end
  end
end
