require "test_helper"

class UsersLoginTest < ActionDispatch::IntegrationTest
  test "login with invalid information" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: {email: 'invalid', password: 'foobar'}}
    assert_response :unprocessable_entity
    assert_template 'sessions/new'
    refute flash.empty?
    get root_path
    assert flash.empty?
  end
end
