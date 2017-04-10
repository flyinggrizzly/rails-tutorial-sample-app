require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: 'Mac Duff', email: 'mac@duff.com')
  end

  test 'user should be valid' do
    @user.valid?
  end

  test 'name should be present' do
    @user.name = '   '
    assert_not @user.valid?
  end

  test 'name should not be too long' do
    @user.name = 'a' * 51
    assert_not @user.valid?
  end

  test 'email should be present' do
    @user.email = '   '
    assert_not @user.valid?
  end

  test 'email should not be too long' do
    @user.email = 'a' * 244 + '@example.org'
    assert_not @user.valid?
  end
end
