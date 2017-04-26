require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:didi)
  end

  test 'unsuccessful edit' do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name:          '',
                                              email:         'foo@invalid',
                                              password:              'foo',
                                              password_confirmation: 'bar' } }
    assert_template 'users/edit'
    assert_select 'div.alert', 'The form contains 4 errors.'
    assert_select '.field_with_errors', count: 8 # two generated per error
  end

  test 'successful edit with friendly forwarding' do
    get edit_user_path(@user)
    assert_redirected_to login_path
    log_in_as(@user)
    assert_redirected_to edit_user_url(@user)

    name = 'Foo Bar'
    email = 'foo@bar.com'

    patch user_path(@user), params: { user: { name:                  name,
                                              email:                 email,
                                              password:              '',
                                              password_confirmation: '' } }

    assert_not flash.empty?
    assert_redirected_to user_path(@user)
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end

  test 'friendly forward should store intended destination url and purge after use' do
    get edit_user_path(@user)
    assert_redirected_to login_url
    assert_equal edit_user_url(@user), session[:intended_destination_url]
    log_in_as(@user)
    assert session[:intended_destination_url].nil?
  end
end
