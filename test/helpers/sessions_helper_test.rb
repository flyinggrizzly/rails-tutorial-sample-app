require 'test_helper'

class SessionsHelperTest < ActionView::TestCase

  def setup
    @user = users(:didi)
    remember(@user)
  end

  test 'current_user returns right user when session is nil' do
    assert_equal @user, current_user
    assert is_logged_in?
  end

  test 'current_user returns right user when remember digest is wrong' do
    @user.update_attribute(:remember_digest, User.digest(User.new_token))
    assert_nil current_user
  end

  test 'remember digest cookie expires after 10 days' do
    # Apparently... this is harder than I thought. TODO: do this.
  end
end
