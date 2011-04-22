module Yads
  class ConfigNotFound < Errno::ENOENT; end

  autoload :SSH, "yads/ssh"
  autoload :Deployer, "yads/deployer"
end
