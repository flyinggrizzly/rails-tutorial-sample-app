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

  test 'email validation should accept valid addresses' do
    valid_addys = %w(user@example.com USER@example.com
                     A_US-ER@foo.bar.org first.last@foo.jp
                     alice+bob@baz.cn)
    valid_addys.each do |addy|
      @user.email = addy
      assert @user.valid?, "#{addy} should be valid"
    end
  end

  test 'email validation should reject invalid addresses' do
    bad_addys = %w(user@example,com user_at_foo.org user.name@example.
                   foo@bar_baz.com foo@bar+baz.com foo@bar..com)
    bad_addys.each do |addy|
      @user.email = addy
      assert_not @user.valid?, "#{addy} should not be valid"
    end
  end

  test 'email should be unique' do
    dupe_user = @user.dup

    # use new email so tests are not order dependent
    EMAIL = 'mac@duff.org'.freeze
    # make sure catch case differences
    @user.email     = EMAIL.upcase
    dupe_user.email = EMAIL.downcase

    @user.save
    assert_not dupe_user.valid?
  end

  test 'email should be saved as lowercase' do
    caps_email = 'BOSS@EMAIL.COM'
    @user.email = caps_email
    @user.save
    assert_equal caps_email.downcase, @user.reload.email
  end
end
