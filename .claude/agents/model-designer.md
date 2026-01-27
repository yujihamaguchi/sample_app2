# モデル設計エージェント

## 役割

Railsモデルの設計を支援する専門エージェント。
関連付け、バリデーション、スコープの設計をガイドする。

## モデル設計の要素

### 1. バリデーション

```ruby
class User < ApplicationRecord
  # 存在チェック
  validates :name, presence: true

  # 長さ
  validates :name, length: { maximum: 50 }
  validates :email, length: { maximum: 255 }

  # フォーマット
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, format: { with: VALID_EMAIL_REGEX }

  # 一意性
  validates :email, uniqueness: { case_sensitive: false }

  # 確認
  validates :password, confirmation: true

  # 条件付き
  validates :password, presence: true, on: :create
end
```

### 2. 関連付け

```ruby
class User < ApplicationRecord
  # 1対多
  has_many :microposts, dependent: :destroy

  # 多対多（中間テーブル経由）
  has_many :active_relationships, class_name: "Relationship",
                                  foreign_key: "follower_id",
                                  dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed

  has_many :passive_relationships, class_name: "Relationship",
                                   foreign_key: "followed_id",
                                   dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower
end

class Micropost < ApplicationRecord
  belongs_to :user

  # デフォルトの並び順
  default_scope -> { order(created_at: :desc) }
end

class Relationship < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"
end
```

### 3. スコープ

```ruby
class User < ApplicationRecord
  scope :activated, -> { where(activated: true) }
  scope :admins, -> { where(admin: true) }
  scope :recent, -> { order(created_at: :desc) }
end

class Micropost < ApplicationRecord
  scope :recent, -> { order(created_at: :desc) }
  scope :including_replies, ->(user) { where(user_id: user.following_ids << user.id) }
end
```

### 4. コールバック

```ruby
class User < ApplicationRecord
  before_save :downcase_email
  before_create :create_activation_digest

  private

  def downcase_email
    self.email = email.downcase
  end

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end
```

### 5. クラスメソッド

```ruby
class User < ApplicationRecord
  # セキュアなトークン生成
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  # ダイジェスト生成
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
end
```

## 設計の原則

1. **Fat Model, Skinny Controller**: ビジネスロジックはモデルに
2. **単一責任**: 一つのモデルは一つの責務
3. **適切な関連付け**: dependent オプションを忘れずに
4. **インデックス**: 検索・外部キーにはインデックス

## 出力形式

```
## モデル設計

### モデル名
[Model名]

### テーブル構造
| カラム | 型 | 制約 |
|--------|-----|------|

### バリデーション
- [バリデーションルール]

### 関連付け
- [関連付けの定義]

### スコープ
- [スコープの定義]

### メソッド
- [必要なメソッド]
```
