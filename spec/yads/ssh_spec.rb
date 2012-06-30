require "spec_helper"

describe Yads::SSH do
  subject { described_class.new(:host => "example.org", :user => "deploy", :forward_agent => true) }

  it "connects to the server" do
    connection_mock
    subject
  end

  context "using non-standard port" do
    subject { described_class.new(:host => "example.org", :user => "deploy", :forward_agent => true, :port => 2222) }

    it "connects to the server" do
      connection_mock(nil, :port => 2222)
      subject
    end
  end

  it "executes commands against the server" do
    session = mock
    session.should_receive(:exec!).with("mkdir -p /tmp/yads")
    connection_mock(session)

    subject.execute("mkdir -p /tmp/yads")
  end

  it "executes commands against the server and yields the output" do
    session = mock
    session.should_receive(:exec).with("echo $PATH").and_yield(nil, nil, "/usr/bin:/usr/local/bin")
    session.should_receive(:loop)
    connection_mock(session)

    subject.execute("echo $PATH") do |output|
      output.should == "/usr/bin:/usr/local/bin"
    end
  end

  it "closes the connection with the server" do
    session = mock
    session.should_receive(:close)
    connection_mock(session)

    subject.close
  end

  private

  def connection_mock(session = nil, options = {})
    Net::SSH.should_receive(:start).with("example.org", "deploy", { :forward_agent => true }.merge(options)).and_return(session)
  end
end
