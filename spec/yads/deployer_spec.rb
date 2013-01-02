require "spec_helper"

shared_examples_for Yads::Deployer do
  it "returns available commands" do
    inside_project_root do
      expect(subject.command_names).to eq(["migrate", "touch"])
    end
  end

  it "returns if it has a command configured" do
    inside_project_root do
      expect(subject).to respond_to(:migrate)
    end
  end

  it "executes the command against the server" do
    inside_project_root do
      ssh = mock
      ssh.should_receive(:execute).with("cd #{path} && rake db:migrate")
      Yads::SSH.should_receive(:new).with(:host => "rafaelss.com", :user => "deploy", :forward_agent => true).and_return(ssh)

      subject.migrate
    end
  end

  context "setting up" do
    it "raises an error if config is not found" do
      expect do
        Dir.chdir("/tmp") do
          subject.setup
        end
      end.to raise_error(Yads::ConfigNotFound)
    end

    it "executes commands against the server" do
      inside_project_root do
        ssh = mock
        ssh.should_receive(:execute).with("mkdir -p #{path} && cd #{path} && git clone --depth 1 git@repohost.com:myrepo.git .")
        Yads::SSH.should_receive(:new).with(:host => "rafaelss.com", :user => "deploy", :forward_agent => true).and_return(ssh)

        subject.setup
      end
    end
  end

  context "deploying" do
    it "raises an error if config is not found" do
      expect do
        Dir.chdir("/tmp") do
          subject.deploy
        end
      end.to raise_error(Yads::ConfigNotFound)
    end

    it "executes commands against the server" do
      inside_project_root do
        ssh = mock
        ssh.should_receive(:execute).with("cd #{path} && rake db:migrate && touch test")
        Yads::SSH.should_receive(:new).with(:host => "rafaelss.com", :user => "deploy", :forward_agent => true).and_return(ssh)

        subject.deploy
      end
    end
  end
end

describe Yads::Deployer do
  let(:log_file) { File.open("/dev/null", "w") }

  context "without environment" do
    let(:path) { "/tmp/yads" }
    subject { described_class.new(nil, log_file) }

    before do
      silence_warnings do
        described_class::CONFIG_FILE = "config/deploy.yml"
      end
    end

    it_behaves_like Yads::Deployer

    context "using non-standard port" do
      before do
        silence_warnings do
          described_class::CONFIG_FILE = "config/deploy_with_port.yml"
        end
      end

      it "sets up the app" do
        inside_project_root do
          ssh = mock
          ssh.should_receive(:execute).with("mkdir -p #{path} && cd #{path} && git clone --depth 1 git@repohost.com:myrepo.git .")
          Yads::SSH.should_receive(:new).with(:host => "rafaelss.com", :user => "deploy", :forward_agent => true, :port => 2222).and_return(ssh)

          subject.setup
        end
      end

      it "deploys the app" do
        inside_project_root do
          ssh = mock
          ssh.should_receive(:execute).with("cd #{path} && rake db:migrate && touch test")
          Yads::SSH.should_receive(:new).with(:host => "rafaelss.com", :user => "deploy", :forward_agent => true, :port => 2222).and_return(ssh)

          subject.deploy
        end
      end
    end
  end

  context "with environment" do
    let(:path) { "/tmp/staging/yads" }
    subject { described_class.new("staging", log_file) }

    before do
      silence_warnings do
        described_class::CONFIG_FILE = "config/deploy_to_staging.yml"
      end
    end

    it "raises an error if environment is not configured in config file" do
      expect do
        inside_project_root { described_class.new("production").deploy }
      end.to raise_error(Yads::UnknowEnvironment)
    end

    it_behaves_like Yads::Deployer
  end

  def inside_project_root(&block)
    Dir.chdir(File.expand_path("../../fixtures", __FILE__), &block)
  end
end
