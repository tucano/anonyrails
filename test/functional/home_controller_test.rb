require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  
  def setup
    @controller = HomeController.new
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new
  end

  def test_index
    get :index
    assert_response :success
  end

  def test_get_template
    get :index
    assert_template 'home'
  end

  def test_request_env
    get :index
    assert_equal :get, @request.request_method
    assert_equal 'test.host', @request.host
  end

  def test_page_response
    get :index
    assert_select "title"
    assert_select "div#request-list" do
      assert_select "table#request-table"
    end
  end

end
