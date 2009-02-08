require 'test_helper'

class TargetTest < Test::Unit::TestCase

  def setup
    @urls = load_user_fixtures('target.yml')
  end

  def test_new_target
    @urls.each { |id, testobj| 
      @target = Target.new(testobj['url'],testobj['query'])
      assert_not_nil @target
    }
  end
end
