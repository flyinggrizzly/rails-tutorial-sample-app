require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:didi)
  end

  test 'login with invalid info' do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: ' ', password: ' ' } }
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test 'login with valid information' do
    get login_path
    post login_path, params: { session: { email: @user.email,
                                          password: 'passwordpassword' } }

    assert_redirected_to @user
    follow_redirect!

    assert_template 'users/show'
    assert_select 'a[href=?]', login_path, count: 0
    assert_select 'a[href=?]', logout_path
    assert_select 'a[href=?]', user_path(@user)
  end

  test 'logout should do what it says on the tin' do
    get login_path
    post login_path, params: { session: { email: @user.email,
                                          password: 'passwordpassword' } }

    assert is_logged_in?

    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    follow_redirect!

    assert_select 'a[href=?]', login_path
    assert_select 'a[href=?]', logout_path,      count: 0
    assert_select 'a[href=?]', user_path(@user), count: 0

    # Simulate a user clicking logout in a second window
    delete logout_path
    follow_redirect!
    assert_select 'a[href=?]', login_path
    assert_select 'a[href=?]', logout_path,      count: 0
    assert_select 'a[href=?]', user_path(@user), count: 0
  end

  test 'memorious login should remember user' do
    log_in_as(@user, remember_me: '1')
    # Use `assigns` to access the user instance variables for comparison
    assert_equal cookies['remember_token'], assigns(:user).remember_token
  end

  test 'forgetful login should forget user' do
    # Log in to set the cookie
    log_in_as(@user, remember_me: '1')
    # Log in again to unset the cookie
    log_in_as(@user, remember_me: '0')
    assert_empty cookies['remember_token']
  end
end
