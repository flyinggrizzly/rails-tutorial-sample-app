require 'test_helper'

class RelationshipTest < ActiveSupport::TestCase
  def setup
    @rel = Relationship.new(follower_id: users(:archer).id,
                            followed_id: users(:lana).id)
  end

  test 'should be valid' do
    assert @rel.valid?
  end

  test 'should require a follower id' do
    @rel.follower_id = nil
    assert_not @rel.valid?
  end

  test 'should require a followed id' do
    @rel.followed_id = nil
    assert_not @rel.valid?
  end
end
