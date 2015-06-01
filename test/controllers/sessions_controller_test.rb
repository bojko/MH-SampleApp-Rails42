require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  def setup
    @base_title = 'Ruby on Rails Tutorial Sample App'
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: '1234567', password_confirmation: '1234567')

  end

  test "should get new" do
    get :new
    assert_response :success
    assert_select 'title', "Log in | #{@base_title}"
    assert_select 'form'
    assert_select 'form input', 6   # UTF8 thing, email, password, remember me, CSRF token, Submit
  end
end
