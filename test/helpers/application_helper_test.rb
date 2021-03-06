require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  def setup
    @base_title = 'Rails Tutorial Sample App'
  end

  test 'empty title should produce base title' do
    assert_equal full_title, @base_title
  end

  test 'title string should produce combined title' do
    assert_equal full_title('Hello'), "Hello | #{@base_title}"
  end

  test 'title should be upcased' do
    assert_equal full_title('hello'), "Hello | #{@base_title}"
  end
end
