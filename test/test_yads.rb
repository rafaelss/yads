require "bundler"
Bundler.require

require "minitest/autorun"
require "mocha"

class TestYads < MiniTest::Unit::TestCase

  def setup
    @deployer = Yads::Deployer.new(File.open("/dev/null", "w"))
  end

  def test_check_path_abort
    ssh = mock
    ssh.expects(:exec).with("cd /tmp/yads/.git").yields("ch", :stderr, "data")
    ssh.expects(:exec).with("git clone git@repohost.com:myrepo.git .").yields("ch1", :stderr, "data1")

    assert_raises(SystemExit) do
      @deployer.check_path(ssh, "/tmp/yads", "git clone git@repohost.com:myrepo.git .")
    end
  end

  def test_check_path
    ssh = mock
    ssh.expects(:exec).with("cd /tmp/yads/.git").yields("ch", :stderr, "data")
    ssh.expects(:exec).with("git clone git@repohost.com:myrepo.git .").yields("ch1", :stdout, "data1")
    ssh.expects(:exec).with("cd /tmp/yads")
    ssh.expects(:loop)

    @deployer.check_path(ssh, "/tmp/yads", "git clone git@repohost.com:myrepo.git .")
  end

  def test_load_not_found_config_file
    assert_raises(Yads::ConfigNotFound) do
      Dir.chdir("/tmp") do
        @deployer.deploy
      end
    end
  end

  def test_load_config_file
    Dir.chdir(File.expand_path("../fixtures", __FILE__)) do
      ssh = mock
      ssh.expects(:exec).with("cd /tmp/yads && touch test")
      ssh.expects(:loop)

      @deployer.expects(:check_path).with(ssh)
      Net::SSH.expects(:start).with("rafaelss.com", "deploy", :forward_agent => true).yields(ssh)

      @deployer.deploy
    end
  end
end
