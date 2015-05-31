require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  def setup
    @base_title = 'Ruby on Rails Tutorial Sample App'
  end

  test "should get new" do
    get :new
    assert_response :success
    assert_select 'title', "Log in | #{@base_title}"
    assert_select 'form'
    assert_select 'form input', 4   # email, password, CSRF token, Submit
  end

end
