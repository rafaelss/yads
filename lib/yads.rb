module Yads
  class ConfigNotFound < Errno::ENOENT; end
  class UnknowEnvironment < StandardError; end

  autoload :SSH, "yads/ssh"
  autoload :Deployer, "yads/deployer"
end
