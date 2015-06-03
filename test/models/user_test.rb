require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: '1234567', password_confirmation: '1234567')
  end

  test 'should be valid' do
    assert @user.valid?
  end

# NAME

  test 'name must be present' do
    @user.name = '   '
    assert_not @user.valid?
  end

  test 'name should not be too long' do
    @user.name = 'a' * 51
    assert_not @user.valid?
  end

# EMAIL

  test 'email must be present' do
    @user.email = '   '
    assert_not @user.valid?
  end

  test 'email should not be too long' do
    @user.name = 'a' * 244 + "@example.com"
    assert_not @user.valid?
  end

  test 'email validation should pass for valid email addresses' do
    valid_addresses = %w[user@example.com USER@foo.com A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]

    valid_addresses.each do |addr|
      @user.email = addr
      assert @user.valid?, "#{addr.inspect} should be valid"
    end
  end

  test 'email validation should fail for invalid email addresses' do
    invalid_addresses = %w[user@example,com foo@baz..com USER_at_foo.com A_US-ER@foo. foo@bar_baz.com foo@bar+baz.com]

    invalid_addresses.each do |addr|
      @user.email = addr
      assert_not @user.valid?, "#{addr.inspect} should be invalid"
    end
  end

  test 'email addresses must be unique' do
    duplicate = @user.dup
    duplicate.email = @user.email.upcase
    @user.save!     # Must succeed
    assert_not duplicate.valid?
  end

  test 'email addresses should be downcased on save' do
    mixed_address = "fOo2gTfR@bar.com"
    @user.email = mixed_address
    @user.save!     # Must succeed
    assert_equal mixed_address.downcase, @user.reload.email
  end

# PASSWORDS

  test 'password must be present' do
    @user.password = @user.password_confirmation = ' ' * 6
    assert_not @user.valid?
  end

  test 'password must be a minimum length' do
    @user.password = @user.password_confirmation = 'a' * 5
    assert_not @user.valid?
  end

  test 'authenticated? should return false for a user with a nil digest' do
    assert_not @user.authenticated?(:remember, '')
  end
end
