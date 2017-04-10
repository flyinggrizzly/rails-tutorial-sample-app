require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest

  test 'layout links' do
    get root_path
    assert_template 'static_pages/home'
    assert_select 'a[href=?]', root_path, count: 2
    assert_select 'a[href=?]', help_path
    assert_select 'a[href=?]', about_path
    assert_select 'a[href=?]', contact_path
  end

  test 'pages have correct titles' do
    paths = {''        => root_path,
             'help'    => help_path,
             'about'   => about_path,
             'contact' => contact_path}

    paths.each do |title, path|
      get path
      assert_select 'title', full_title(title)
    end
  end
end
