require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test 'Invalid signup information' do
    get signup_path

    assert_no_difference 'User.count' do
      post users_path, user: { name: '',
                               email: 'user@invalid',
                               password: 'foo',
                               password_confirmation: 'bar' }
    end

    assert_template 'users/new'
  end

  test 'Valid user signup' do
    get signup_path

    assert_difference 'User.count', 1 do
      post_via_redirect users_path, user: { name: 'Valid Username',
                               email: 'user@valid.com',
                               password: 'foobar',
                               password_confirmation: 'foobar' }
    end

    assert_template 'users/show'
  end
end
