require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
  def setup
    @user = users :michael
    # This works, but is not idiomatically correct.
    # @micropost = Micropost.new(content: "Lorem ipsum sic dolor amet", user_id: @user.id)
    # This is what it should be
    @micropost = @user.microposts.build(content: 'Lorem ipsum')
  end

  test 'should be valid' do
    assert @micropost.valid?
  end

  test 'user id must be present' do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end

  test 'content must be present' do
    @micropost.content = nil
    assert_not @micropost.valid?
  end

  test 'content must be less than 140 characters' do
    @micropost.content = 'a' * 141
    assert_not @micropost.valid?
  end

  test 'order should be most recent firsrt' do
    assert_equal microposts(:most_recent), Micropost.first
  end
end
