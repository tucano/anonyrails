require 'test_helper'

class HideControllerTest < ActionController::TestCase

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

end
