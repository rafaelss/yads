require "test_helper"

class TestSSH < MiniTest::Unit::TestCase

  def test_connect
    connection_mock

    Yads::SSH.new(:host => "example.org", :user => "deploy", :forward_agent => true)
  end

  def test_execute
    session = mock
    session.expects(:exec!).with("mkdir -p /tmp/yads")
    connection_mock(session)

    s = Yads::SSH.new(:host => "example.org", :user => "deploy", :forward_agent => true)
    s.execute("mkdir -p /tmp/yads")
  end

  def test_execute_with_block
    session = mock
    session.expects(:exec).with("echo $PATH").yields(nil, nil, "/usr/bin:/usr/local/bin")
    session.expects(:loop)
    connection_mock(session)

    s = Yads::SSH.new(:host => "example.org", :user => "deploy", :forward_agent => true)
    s.execute("echo $PATH") do |output|
      assert_equal "/usr/bin:/usr/local/bin", output
    end
  end

  def test_close
    session = mock
    session.expects(:close)
    connection_mock(session)

    s = Yads::SSH.new(:host => "example.org", :user => "deploy", :forward_agent => true)
    s.close
  end

  private

    def connection_mock(session = nil)
      Net::SSH.expects(:start).with("example.org", "deploy", :forward_agent => true).returns(session)
    end
end
