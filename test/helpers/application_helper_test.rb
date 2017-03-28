require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test 'full title helper' do
    assert_equal full_title, 'Rails Tutorial Sample App'
    assert_equal full_title('Help'), 'Help | Rails Tutorial Sample App'
  end
end
