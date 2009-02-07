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
    assert_template 'home'

    assert_not_nil assigns(:host)
    assert_not_nil assigns(:host_port)
    assert_not_nil assigns(:host_remote)
    assert_not_nil assigns(:host_remoteip)
    assert_not_nil assigns(:host_environment)

    assert_select "title"
    
    assert_select "div#main" do
      assert_select "table#home-table"
    end
    
    assert_select "div#request-environment" do
      assert_select "table#request-table"
    end

  end

end
