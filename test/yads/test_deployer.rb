require "test_helper"

class TestYads < MiniTest::Unit::TestCase

  def setup
    @log_file = File.open("/dev/null", "w")
  end

  def test_try_loading_not_found_config_file_on_setup
    assert_raises(Yads::ConfigNotFound) do
      Dir.chdir("/tmp") do
        deployer = Yads::Deployer.new(@log_file)
        deployer.setup
      end
    end
  end

  def test_try_loading_not_found_config_file_on_deploy
    assert_raises(Yads::ConfigNotFound) do
      Dir.chdir("/tmp") do
        deployer = Yads::Deployer.new(@log_file)
        deployer.deploy
      end
    end
  end

  def test_setup
    inside_project_root do
      ssh = mock
      ssh.expects(:execute).with("mkdir -p /tmp/yads && cd /tmp/yads && git clone --depth 1 git@repohost.com:myrepo.git .")
      Yads::SSH.expects(:new).with(:host => "rafaelss.com", :user => "deploy", :forward_agent => true).returns(ssh)

      deployer = Yads::Deployer.new(@log_file)
      deployer.setup
    end
  end

  def test_deploy
    inside_project_root do
      ssh = mock
      ssh.expects(:execute).with("cd /tmp/yads && rake db:migrate && touch test")
      Yads::SSH.expects(:new).with(:host => "rafaelss.com", :user => "deploy", :forward_agent => true).returns(ssh)

      deployer = Yads::Deployer.new(@log_file)
      deployer.deploy
    end
  end

  private

    def inside_project_root(&block)
      Dir.chdir(File.expand_path("../../fixtures", __FILE__), &block)
    end
end
