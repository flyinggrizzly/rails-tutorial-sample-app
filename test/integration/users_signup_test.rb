require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  def setup
    @user_hash = { name:                  'Mac Duff',
                   email:                 'foo@bar.org',
                   password:              'foobarfoobar',
                   password_confirmation: 'foobarfoobar' }

    @bad_hash = { name:                  '',
                  email:                 'foo@bar',
                  password:              'foobarfoob',
                  password_confirmation: 'foobrfoobar' }
    ActionMailer::Base.deliveries.clear
  end

  test 'invalid signup info should not be accepted' do
    get signup_path
    assert_no_difference 'User.count' do
      assert_select 'form[action="/signup"]' # ensure right post path

      post signup_path, params: { user: @bad_hash }
    end
    assert_template 'users/new'
  end

  test 'error corrections should appear' do
    get signup_path
    assert_select 'form[action="/signup"]' # ensure right post path

    post signup_path, params: { user: @bad_hash }
    assert_select '.field_with_errors', count: 8 # two classed elements are produced per error
    assert_select '#error_explanation'
  end

  test 'signup error messages should be accurate' do
    @user_hash.keys.each do |key|
      hash = @user_hash.dup
      hash[key] = '' # Emptiness is definitely a sin for all of these...

      get signup_path
      assert_select 'form[action="/signup"]' # ensure right post path

      post signup_path, params: { user: hash }

      assert_select '.error_message', User.new(hash).errors.full_messages.first, "empty #{key} should not be valid"
    end
  end

  test 'valid signup data with activation should be successful' do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: @user_hash }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.activated

    # Try to log in before activation
    log_in_as(user)
    assert_not is_logged_in?

    # Valid email, bad token
    get edit_account_activation_path('invalid token', email: user.email)
    assert_not is_logged_in?

    # Bad email, valid token
    get edit_account_activation_path(user.activation_token, email: 'bad@email.org')
    assert_not is_logged_in?

    # Valid email and token
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
  end
end
