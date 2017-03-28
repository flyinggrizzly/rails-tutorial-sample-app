require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest

  def setup
    @basetitle = 'Rails Tutorial Sample App'
  end

  test 'should get root' do
    get root_url
    assert_response :success
    assert_select('title', @basetitle)
  end

  test 'should get home' do
    get home_url
    assert_response :redirect
  end

  test 'should get help' do
    get help_url
    assert_response :success
    assert_select('title', "Help | #{@basetitle}")
  end

  test 'should get about' do
    get about_url
    assert_response :success
    assert_select('title', "About | #{@basetitle}")
  end

  test 'should get contact' do
    get contact_url
    assert_response :success
    assert_select('title', "Contact | #{@basetitle}")
  end
end
