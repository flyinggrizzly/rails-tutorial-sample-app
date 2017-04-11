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
  end

  test 'invalid signup info should not be accepted' do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: @bad_hash }
    end
    assert_template 'users/new'
  end

  test 'error corrections should appear' do
    get signup_path
    post users_path, params: { user: @bad_hash }
    assert_select '.field_with_errors', count: 8 # two classed elements are produced per error
    assert_select '#error_explanation'
  end

  test 'signup error messages should be accurate' do
    @user_hash.keys.each do |key|
      hash = @user_hash.dup
      hash[key] = '' # Emptiness is definitely a sin for all of these...

      get signup_path
      post users_path, params: { user: hash }

      assert_select '.error_message', User.new(hash).errors.full_messages.first, "empty #{key} should not be valid"
    end
  end
end
