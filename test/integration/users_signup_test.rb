require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test 'all fields present' do
    get signup_path

    assert_select 'form'
    assert_select 'form input', 6
  end

  test 'Invalid signup information' do
    get signup_path

    assert_no_difference 'User.count' do
      post users_path, user: { name: '',
             email: 'user@invalid',
             password: 'foo',
             password_confirmation: 'bar' }
    end

    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select '.field_with_errors'
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
    assert_select '.alert-success'
  end
end
