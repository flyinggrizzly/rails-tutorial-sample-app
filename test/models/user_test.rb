require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name:                  'Mac Duff',
                     email:                 'mac@duff.com',
                     password:              'foobarfoobar',
                     password_confirmation: 'foobarfoobar')
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
    caps_email  = 'BOSS@EMAIL.COM'
    @user.email = caps_email
    @user.save
    assert_equal caps_email.downcase, @user.reload.email
  end

  test 'password should be non-blank' do
    @user.password = ' ' * 12
    @user.password_confirmation = ' ' * 12
    assert_not @user.valid?
  end

  test 'password should be long enough' do
    @user.password = 'a' * 11
    @user.password_confirmation = 'a' * 11
    assert_not @user.valid?
  end

  test 'remember should set token' do
    @user.save
    old_rem_digest = @user.remember_digest
    @user.remember
    assert_not @user.remember_digest == old_rem_digest
  end

  test 'authenticated? should return false for a user with nil digest' do
    assert_not @user.authenticated?(:remember, '')
  end

  test 'associated posts should be destroyed' do
    @user.save
    @user.microposts.create!(content: 'Lorem ipsum')
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end

  test 'should follow and unfollow a user' do
    archer = users(:archer)
    lana   = users(:lana)

    assert_not archer.following?(lana)

    assert_difference 'archer.following.size', 1 do
      archer.follow(lana)
    end
    assert archer.following?(lana)
    assert lana.followers.include?(archer)

    assert_difference 'archer.following.size', -1 do
      archer.unfollow(lana)
    end
    assert_not archer.following?(lana)
    assert_not lana.followers.include?(archer)
  end
end
