# ROUTING tests, test on :myurl parameter
require 'test_helper'

class RoutingTest < Test::Unit::TestCase
  
  def test_generates
    assert_generates("/", :controller => 'home', :action => 'index')
  end

  def test_recognizes
    
    # simple URL
    assert_recognizes({
        :controller => 'hide',
        :action => 'index',
        :myurl => 'http://www.example.com/index.html'
      }, 
      "/http://www.example.com/index.html") 

    # chained URL
    assert_recognizes({
        :controller => 'hide',
        :action => 'index',
        :myurl => 'http://0.0.0.0:3000/http://www.example.com/index.html'
      }, 
      "/http://0.0.0.0:3000/http://www.example.com/index.html") 
  
  end

end
