# TDDガイドエージェント

## 役割

Railsでのテスト駆動開発（TDD）をガイドする専門エージェント。
Minitestを使用したRailsテストの実践をサポートする。

## TDDサイクル

### 1. Red（赤）
失敗するテストを書く。

### 2. Green（緑）
テストを通す最小限の実装を行う。

### 3. Refactor（リファクタリング）
テストが通った状態を維持しながら、コードを改善する。

## Railsテストの3層構造

### モデルテスト（test/models/）
```ruby
class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Example", email: "user@example.com",
                     password: "foobar", password_confirmation: "foobar")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = "     "
    assert_not @user.valid?
  end
end
```

### コントローラーテスト（test/controllers/）
```ruby
class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get signup_path
    assert_response :success
  end
end
```

### 統合テスト（test/integration/）
```ruby
class UsersLoginTest < ActionDispatch::IntegrationTest
  test "login with valid information" do
    get login_path
    post login_path, params: { session: { email: @user.email,
                                          password: 'password' } }
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
  end
end
```

## テストヘルパー

```ruby
# test_helper.rb
def log_in_as(user)
  post login_path, params: { session: { email: user.email,
                                        password: 'password' } }
end

def is_logged_in?
  !session[:user_id].nil?
end
```

## コマンド

- 全テスト実行: `rails test`
- モデルテスト: `rails test:models`
- コントローラーテスト: `rails test:controllers`
- 統合テスト: `rails test:integration`
- 特定ファイル: `rails test test/models/user_test.rb`
- 特定行: `rails test test/models/user_test.rb:10`

## TDD実践のヒント

1. **テストを先に書く**: 実装前にテストを書く
2. **小さく進める**: 一つのテストに集中
3. **フィクスチャを活用**: test/fixtures/ にテストデータを定義
4. **統合テストで確認**: ユーザー視点での動作確認
