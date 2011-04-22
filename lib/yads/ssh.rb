require "net/ssh"

module Yads

  class SSH

    def initialize(config)
      @ssh = Net::SSH.start(config[:host], config[:user], :forward_agent => config[:forward_agent])
    end

    def execute(cmd)
      if block_given?
        @ssh.exec(cmd) do |ch, stream, data|
          yield data
        end
      else
        @ssh.exec!(cmd)
      end
    end

    def close
      @ssh.close
    end
  end
end
