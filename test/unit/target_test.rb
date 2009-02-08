require 'test_helper'

class TargetTest < Test::Unit::TestCase

  def setup
    @targets = load_user_fixtures('target.yml')
  end

  def test_new_target
    @targets.each { |id, testobj| 
      target = Target.new(testobj['url'],testobj['query'],testobj['method'])
      assert_not_nil target.url
      assert_not_nil target.url.host
      assert_not_nil target.url.path
      assert_equal testobj['query'], target.url.query
      assert_equal testobj['method'], target.method
    }
  end

  def test_parse_body
    @targets.each { |id, testobj| 
      target = Target.new(testobj['url'],testobj['query'],testobj['method'])
      target.body = testobj['body']
      assert_not_nil target.parse_body('test.host',80)
    }
  end

end
