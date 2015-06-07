require 'test_helper'

class MicropostsControllerTest < ActionController::TestCase
  def setup
    @post = microposts :orange
  end

  test "should redirect create when not logged in" do
    assert_no_difference 'Micropost.count' do
      post :create, micropost: { content: 'Lorem Ipsum' }
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'Micropost.count' do
      delete :destroy, id: @post
    end
    assert_redirected_to login_url
  end
end
