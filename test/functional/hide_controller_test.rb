require 'test_helper'

class HideControllerTest < ActionController::TestCase
  
  #
  # SAFE URLS 
  # 1. www.example.com for general testing
  # 2. http://jigsaw.w3.org/HTTP/300/302.html FOR testing redirect
  #
  
  def setup
    @controller = HideController.new
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new
  end

  def test_get_with_index_page
    get :index, :myurl => 'http://www.example.com/index.html'
    assert_response :success
  end
  
  def test_get_with_hostname_only
    get :index, :myurl => 'http://www.example.com'
    assert_response :success
  end

  def test_follow_redirection
    get :index, :myurl => 'http://jigsaw.w3.org/HTTP/300/302.html'
    assert_response :redirect
    get :index, :myurl => 'http://jigsaw.w3.org/HTTP/300/301.html'
    assert_response :redirect
    get :index, :myurl => 'http://jigsaw.w3.org/HTTP/300/307.html'
    assert_response :redirect
  end

end
