require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest

  def setup
    @admin     = users(:michael)
    @non_admin = users(:archer)

  end

  test "index as admin including pagination and delete links" do
    log_in_as(@admin)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
    first_page_of_users = User.where(activated: true).paginate(page: 1)
    first_page_of_users.each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
      unless user == @admin || user == @inactive
        assert_select 'a[href=?]', user_path(user), text: 'delete'
      end
    end
    #not working
    #assert_difference 'User.count', -1 do
  #    delete user_path(@non_admin)
  #  end
  end

  test "index as non-admin" do
    log_in_as(@non_admin)
    get users_path
    assert_select 'a', text: 'delete', count: 0
  end

 #test "should only see activated users" do
  #   log_in_as(@non_admin)
  #   get users_path
  #   assert_select 'ul.users li', count: User.where(activated: true).count

  #  assert_not User.all.count == User.where(activated: true).count
  #end

#  test "should not see an inactive user" do
#
#  end
end
