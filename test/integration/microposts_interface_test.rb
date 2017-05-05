require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @user  = users(:archer)
    @admin = users(:godot)
  end

  test 'creating microposts' do
    log_in_as(@user)
    get root_path
    assert_select 'div.pagination'
    assert_select 'input[type=file]'

    # Invalid post submission
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: { content: '' } }
    end
    assert_select 'div#error_explanation'

    # Valid submission
    content = 'I am a golden god!'
    picture = fixture_file_upload('test/fixtures/rails.png', 'image/png')
    assert_difference 'Micropost.count', 1 do
      post microposts_path, params: { micropost: { content: content, picture: picture } }
    end
    assert assigns(:micropost).picture?
    assert_redirected_to root_url
    follow_redirect!
    assert_match content, response.body
  end

  test 'deleting microposts' do
    log_in_as(@user)
    get root_path

    assert_select 'a', text: 'delete'
    first_micropost = @user.microposts.paginate(page: 1).first
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(first_micropost)
    end
  end

  test 'deleting microposts without js' do
    log_in_as(@user)
    post = @user.microposts.paginate(page: 1).first

    get delete_micropost_path(post)
    assert_match post.content, response.body
    assert_select 'form input[type=submit][value="Destroy"]'

    assert_difference 'Micropost.count', -1 do
      delete micropost_path(post)
    end
  end

  test 'users should only be able to delete own posts' do
    # logged out user
    get user_path(users(:lana))
    assert_select 'a', text: 'delete', count: 0

    # logged in as wrong user
    log_in_as(@user)
    get user_path(users(:lana))
    assert_select 'a', text: 'delete', count: 0

    # Check are redirected from delete page
    lana_post = users(:lana).microposts.paginate(page: 1).first
    get delete_micropost_path(lana_post)
    assert_response :redirect
  end

  test 'admins should be able to delete posts' do
    log_in_as(@admin)
    first_micropost = @user.microposts.paginate(page: 1).first
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(first_micropost)
    end
  end

  test 'micropost sidebar count' do
    log_in_as(@user)
    get root_path
    assert_match "#{@user.microposts.count} microposts", response.body

    # User with zero microposts
    other_user = users(:cyril)
    log_in_as(other_user)
    get root_path
    assert_match '0 microposts', response.body

    # User with 1 micropost
    other_user.microposts.create!(content: 'A micropost')
    get root_path
    assert_match '1 micropost', response.body
  end
end
