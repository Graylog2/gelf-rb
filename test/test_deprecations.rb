require 'helper'

class TestDeprecations < Test::Unit::TestCase
  context "with Gelf object" do
    setup do
      @verbose, $VERBOSE = $VERBOSE, nil
      @g = Gelf.new('host', 12345)
    end

    teardown do
      $VERBOSE = @verbose
    end

    should "deprecate Gelf.new" do
      assert_equal Gelf, @g.class
      assert_equal 'host', @g.notifier.host
      assert_equal 12345, @g.notifier.port
      assert_equal Hash, @g.message.class
    end

    should "deprecate Gelf#send" do
      @g.notifier.expects(:notify).with(@g.message)
      @g.send
    end

    [:short_message, :full_message, :level, :host, :line, :file].each do |a|
      should "deprecate Gelf##{a} and Gelf##{a}=" do
        @g.__send__("#{a}=", 'value')
        assert_equal 'value', @g.__send__(a)
      end
    end

    should "set add additional params" do
      @g.add_additional(:key, 'value')
      assert_equal 'value', @g.message[:key]
    end
  end
end
