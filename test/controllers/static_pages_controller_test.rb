require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest

  def setup
    @base_title = 'Rails Tutorial Sample App'
  end

  test 'root should get home' do
    get root_path
    assert_response :success
    assert_select 'title', @base_title
  end

  test 'home should redirect to root' do
    get home_path
    assert_redirected_to '/'
  end

  test 'should get help' do
    get help_path
    assert_response :success
    assert_select 'title', 'Help | ' + @base_title
  end

  test 'should get about' do
    get about_path
    assert_response :success
    assert_select 'title', 'About | ' + @base_title
  end

  test 'should get contact' do
    get contact_path
    assert_response :success
    assert_select 'title', 'Contact | ' + @base_title
  end
end
