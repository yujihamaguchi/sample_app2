# CLAUDE.md

このファイルは、このリポジトリでコードを作業する際にClaude Code (claude.ai/code) に対してガイダンスを提供します。

## プロジェクト概要

このプロジェクトは「Ruby on Rails チュートリアル」（Michael Hartl著、第7版）のサンプルアプリケーションです。Twitterライクなソーシャルネットワーキングアプリケーションで、以下の機能を実装しています：

- ユーザー認証（ログイン/ログアウト/セッション管理）
- ユーザー登録・プロフィール編集
- マイクロポスト（短文投稿）
- フォロー/フォロワー機能

## 技術スタック

- Ruby 3.2.4
- Rails 7.0.4.3
- SQLite（開発/テスト）/ PostgreSQL（本番）
- Bootstrap 3.4.1
- Minitest

## 主要アーキテクチャ

### モデル
- **User**: ユーザー（認証、プロフィール、フォロー関係）
- **Micropost**: マイクロポスト（ユーザーの投稿）
- **Relationship**: フォロー関係（多対多の中間テーブル）

### コントローラー
- **UsersController**: ユーザーCRUD
- **SessionsController**: ログイン/ログアウト
- **MicropostsController**: 投稿の作成/削除
- **RelationshipsController**: フォロー/アンフォロー
- **StaticPagesController**: 静的ページ

## 共通開発コマンド

### サーバー起動
```bash
rails server
```

### テスト実行
```bash
rails test                              # 全テスト
rails test:models                       # モデルテスト
rails test:controllers                  # コントローラーテスト
rails test:integration                  # 統合テスト
rails test test/models/user_test.rb     # 特定ファイル
rails test test/models/user_test.rb:10  # 特定行
```

### データベース
```bash
rails db:migrate          # マイグレーション実行
rails db:rollback         # ロールバック
rails db:migrate:status   # 状態確認
rails db:seed             # シードデータ投入
rails db:reset            # リセット（drop + create + migrate + seed）
```

### コンソール
```bash
rails console             # 対話コンソール
rails console --sandbox   # ロールバックされるサンドボックスモード
```

### ジェネレーター
```bash
rails generate model ModelName field:type
rails generate controller ControllerName action1 action2
rails generate migration AddColumnToTable column:type
```

## テストパターン

- テストは `test/` ディレクトリに配置
- モデルテスト: `test/models/`
- コントローラーテスト: `test/controllers/`
- 統合テスト: `test/integration/`
- フィクスチャ: `test/fixtures/`
- テストヘルパー: `test/test_helper.rb`（log_in_as, is_logged_in?）

## コーディング規約

- Rails規約に従う（CoC: Convention over Configuration）
- RESTfulなルーティング
- Fat Model, Skinny Controller
- Strong Parametersによるマスアサインメント対策
- before_actionによる認証・認可
- パーシャルによるビューの分割

---

# Rails to Clean Architecture Migration Plan

## 目標

段階的にドメイン層を隔離し、ドメインモデリングとデータモデリングの強みをそれぞれ最大限に活かせる環境を構築する。最終的にRailsにとって無理のない形でクリーンアーキテクチャを実現する。

## アーキテクチャ方針

### ディレクトリ構造

```
app/
├── models/                    # Active Record（データ層として保持）
├── domain/                    # 新規: 純粋なドメインロジック
│   ├── entities/             # エンティティ
│   ├── value_objects/        # 値オブジェクト
│   ├── services/             # ドメインサービス
│   └── repositories/         # リポジトリインターフェース
├── usecases/                  # 新規: アプリケーション層
├── repositories/              # 新規: リポジトリ実装
│   └── active_record/        # Active Record実装
└── controllers/               # コントローラー（UseCaseを呼び出す形に変更）
```

### レイヤー分離の原則

1. **ドメイン層**: フレームワークに依存しない純粋なビジネスロジック
2. **アプリケーション層**: UseCaseでビジネスフローを表現
3. **インフラ層**: Active Record、コントローラー、ビュー
4. **依存方向**: 外側→内側（インフラ→アプリケーション→ドメイン）

## 段階的移行戦略

### Phase 0: 基盤整備（1週間）

**目的**: ディレクトリ構造とベースクラスの準備

**作成ファイル**:
- `config/application.rb` - autoload設定追加
- `app/domain/entity.rb` - エンティティベースクラス
- `app/domain/value_object.rb` - 値オブジェクトベースクラス
- `app/usecases/base_usecase.rb` - UseCaseベースクラス（Result型含む）
- `app/domain/repositories/repository.rb` - リポジトリ基底インターフェース

**検証**: `rails console`でベースクラスが読み込めること

### Phase 1: Micropostドメイン移行（1-2週間）

**なぜMicropostから？**: 最もシンプル（6行）、依存少ない、低リスク

**実装内容**:

1. **値オブジェクト作成**
   - `app/domain/value_objects/micropost_content.rb` - 140文字制限、バリデーション

2. **エンティティ作成**
   - `app/domain/entities/micropost_entity.rb` - 純粋なドメインモデル

3. **リポジトリ作成**
   - `app/domain/repositories/micropost_repository.rb` - インターフェース
   - `app/repositories/active_record/micropost_repository.rb` - Active Record実装

4. **UseCase作成**
   - `app/usecases/microposts/create_micropost.rb`
   - `app/usecases/microposts/delete_micropost.rb`

5. **コントローラー更新**
   - `app/controllers/microposts_controller.rb` - UseCaseを呼び出す形に変更

**テスト**:
- 値オブジェクトの単体テスト（DB不要）
- エンティティのテスト
- リポジトリのテスト（DB使用）
- UseCaseのテスト
- 既存の統合テストが通ることを確認

**検証**: マイクロポスト作成・削除が正常動作すること

### Phase 2: Relationshipドメイン移行（1-2週間）

**なぜRelationshipが次？**: 中程度の複雑さ、ドメインサービスパターンの導入に最適

**実装内容**:

1. **エンティティ作成**
   - `app/domain/entities/relationship_entity.rb` - 自己フォロー禁止などのバリデーション

2. **ドメインサービス作成**
   - `app/domain/services/follow_service.rb` - フォロー/アンフォローのビジネスロジック

3. **リポジトリ作成**
   - `app/domain/repositories/relationship_repository.rb`
   - `app/repositories/active_record/relationship_repository.rb`

4. **UseCase作成**
   - `app/usecases/relationships/follow_user.rb`
   - `app/usecases/relationships/unfollow_user.rb`

5. **コントローラー更新**
   - `app/controllers/relationships_controller.rb`

**テスト**:
- ドメインサービスの単体テスト
- フォロー/アンフォローの統合テスト

**検証**: フォロー機能が正常動作すること

### Phase 3: Userドメイン移行（2-3週間）

**最も複雑**: 7つの責務を持つため、段階的に分離

**実装内容**:

1. **値オブジェクト作成**
   - `app/domain/value_objects/email.rb` - メール形式バリデーション
   - `app/domain/value_objects/password.rb` - パスワード暗号化・検証
   - `app/domain/value_objects/user_name.rb` - 名前バリデーション

2. **エンティティ作成**
   - `app/domain/entities/user_entity.rb` - コアユーザーエンティティ

3. **ドメインサービス作成**
   - `app/domain/services/authentication_service.rb` - 認証ロジック
   - `app/domain/services/feed_service.rb` - フィード生成ロジック

4. **リポジトリ作成**
   - `app/domain/repositories/user_repository.rb`
   - `app/repositories/active_record/user_repository.rb`

5. **UseCase作成**
   - `app/usecases/users/register_user.rb`
   - `app/usecases/users/authenticate_user.rb`
   - `app/usecases/users/update_user_profile.rb`
   - `app/usecases/users/delete_user.rb`
   - `app/usecases/users/list_users.rb`

6. **コントローラー更新**
   - `app/controllers/users_controller.rb`
   - `app/controllers/sessions_controller.rb`

7. **ヘルパー更新**
   - `app/helpers/sessions_helper.rb` - 認証サービスを使用する形に

**テスト**:
- 値オブジェクトの単体テスト
- 認証サービスのテスト
- ユーザー登録・更新のテスト

**検証**: ユーザー登録、ログイン、プロフィール編集が正常動作すること

### Phase 4: 最適化と完成（3-4週間）

**実装内容**:

1. **Active Recordモデルの簡素化**
   - `app/models/user.rb` - ビジネスロジック削除、関連とバリデーションのみ残す
   - `app/models/micropost.rb` - 同様に簡素化
   - `app/models/relationship.rb` - 同様に簡素化

2. **依存性注入コンテナ（オプション）**
   - `config/initializers/dependencies.rb` - サービスコンテナ

3. **パフォーマンス最適化**
   - N+1クエリの解消
   - キャッシング戦略
   - インデックス追加

4. **ドキュメント作成**
   - アーキテクチャ決定記録（ADR）
   - ドメインモデル図
   - 開発ガイド

**検証**: 全テスト通過、パフォーマンス維持・向上

## DDDパターン適用

### リポジトリパターン

- データアクセスをインターフェース化
- ドメイン層はリポジトリ経由でのみデータ取得
- テスト時はインメモリリポジトリで置き換え可能

### 値オブジェクト

- Email, Password, UserName, MicropostContent
- バリデーションロジックをカプセル化
- イミュータブル（不変）

### ドメインサービス

- FollowService: フォロー/アンフォローロジック
- AuthenticationService: 認証ロジック
- FeedService: フィード生成ロジック

### ファクトリ（必要に応じて）

- 複雑なオブジェクト生成ロジックの分離

## テスト戦略

### 1. ドメイン層テスト（DB不要）

```ruby
# 値オブジェクト、エンティティ、ドメインサービス
# Railsに依存せず、高速にテスト可能
test "email validates format" do
  assert_raises(ArgumentError) do
    Domain::ValueObjects::Email.new("invalid")
  end
end
```

### 2. リポジトリテスト（DB使用）

```ruby
# Active Record実装のテスト
test "repository saves and retrieves entity" do
  entity = Domain::Entities::UserEntity.new(...)
  saved = @repository.create(entity)
  assert_not_nil saved.id
end
```

### 3. UseCaseテスト

```ruby
# ビジネスフローのテスト
test "register user successfully" do
  result = Usecases::Users::RegisterUser.call(...)
  assert result.success?
end
```

### 4. 統合テスト（既存維持）

```ruby
# エンドツーエンドの動作確認
# 既存のtest/integration/のテストを維持
```

## リスクと緩和策

### リスク1: パフォーマンス低下

**緩和策**:
- 各フェーズでベンチマーク実施
- リポジトリでのクエリ最適化
- 必要に応じてキャッシング

### リスク2: 複雑性の増加

**緩和策**:
- シンプルなドメインから開始
- 過度な抽象化を避ける
- Rails規約を尊重

### リスク3: テストカバレッジの低下

**緩和策**:
- 移行前後でテストカバレッジ測定
- ドメイン層のテスト追加
- 既存統合テストを維持

## 既存コードとの共存

- 各フェーズで段階的に移行
- 古いコードと新しいコードが一時的に共存
- フィーチャーフラグで切り替え可能に（必要に応じて）
- いつでもロールバック可能な状態を維持

## 検証方法

### Phase 0
```bash
rails console
# => Domain::Entity が読み込めること
# => Usecases::BaseUsecase が読み込めること
```

### Phase 1
```bash
rails test test/domain/value_objects/micropost_content_test.rb
rails test test/usecases/microposts/
rails test test/integration/microposts_interface_test.rb
rails server
# ブラウザでマイクロポスト作成・削除を確認
```

### Phase 2
```bash
rails test test/domain/services/follow_service_test.rb
rails test test/integration/following_test.rb
# ブラウザでフォロー機能を確認
```

### Phase 3
```bash
rails test test/domain/value_objects/
rails test test/usecases/users/
rails test test/integration/users_login_test.rb
rails test test/integration/users_signup_test.rb
# ブラウザでユーザー登録・ログインを確認
```

### Phase 4
```bash
rails test  # 全テスト実行
rails test:system  # システムテスト
# パフォーマンステスト
# コードカバレッジ確認
```

## 期待される成果

1. **保守性向上**: ビジネスロジックがドメイン層に集約
2. **テスタビリティ向上**: DB不要な高速単体テスト
3. **柔軟性向上**: データ永続化の実装を容易に切り替え可能
4. **可読性向上**: ビジネスルールが明確に表現される
5. **Rails親和性**: Railsの良さを活かしつつ、構造化を実現

## 進捗管理

### Phase 0: 基盤整備 ⏳ 未着手
- [ ] `config/application.rb` - autoload設定追加
- [ ] `app/domain/entity.rb` - エンティティベースクラス作成
- [ ] `app/domain/value_object.rb` - 値オブジェクトベースクラス作成
- [ ] `app/usecases/base_usecase.rb` - UseCaseベースクラス作成
- [ ] `app/domain/repositories/repository.rb` - リポジトリ基底インターフェース作成
- [ ] 検証: `rails console`でベースクラスが読み込めること

### Phase 1: Micropostドメイン移行 ⏳ 未着手
- [ ] `app/domain/value_objects/micropost_content.rb` - 値オブジェクト作成
- [ ] `app/domain/entities/micropost_entity.rb` - エンティティ作成
- [ ] `app/domain/repositories/micropost_repository.rb` - リポジトリインターフェース作成
- [ ] `app/repositories/active_record/micropost_repository.rb` - Active Record実装
- [ ] `test/domain/value_objects/micropost_content_test.rb` - 値オブジェクトテスト
- [ ] `app/usecases/microposts/create_micropost.rb` - UseCase作成
- [ ] `app/usecases/microposts/delete_micropost.rb` - UseCase作成
- [ ] `test/usecases/microposts/` - UseCaseテスト
- [ ] `app/controllers/microposts_controller.rb` - コントローラー更新
- [ ] 検証: マイクロポスト作成・削除が正常動作
- [ ] 既存統合テスト通過確認

### Phase 2: Relationshipドメイン移行 ⏳ 未着手
- [ ] `app/domain/entities/relationship_entity.rb` - エンティティ作成
- [ ] `app/domain/services/follow_service.rb` - ドメインサービス作成
- [ ] `app/domain/repositories/relationship_repository.rb` - リポジトリインターフェース
- [ ] `app/repositories/active_record/relationship_repository.rb` - Active Record実装
- [ ] `test/domain/services/follow_service_test.rb` - ドメインサービステスト
- [ ] `app/usecases/relationships/follow_user.rb` - UseCase作成
- [ ] `app/usecases/relationships/unfollow_user.rb` - UseCase作成
- [ ] `app/controllers/relationships_controller.rb` - コントローラー更新
- [ ] 検証: フォロー機能が正常動作
- [ ] 統合テスト通過確認

### Phase 3: Userドメイン移行 ⏳ 未着手
- [ ] `app/domain/value_objects/email.rb` - Email値オブジェクト作成
- [ ] `app/domain/value_objects/password.rb` - Password値オブジェクト作成
- [ ] `app/domain/value_objects/user_name.rb` - UserName値オブジェクト作成
- [ ] `test/domain/value_objects/` - 値オブジェクトテスト
- [ ] `app/domain/entities/user_entity.rb` - エンティティ作成
- [ ] `app/domain/services/authentication_service.rb` - 認証サービス作成
- [ ] `app/domain/services/feed_service.rb` - フィードサービス作成
- [ ] `app/domain/repositories/user_repository.rb` - リポジトリインターフェース
- [ ] `app/repositories/active_record/user_repository.rb` - Active Record実装
- [ ] `app/usecases/users/register_user.rb` - ユーザー登録UseCase
- [ ] `app/usecases/users/authenticate_user.rb` - 認証UseCase
- [ ] `app/usecases/users/update_user_profile.rb` - プロフィール更新UseCase
- [ ] `app/usecases/users/delete_user.rb` - ユーザー削除UseCase
- [ ] `app/usecases/users/list_users.rb` - ユーザー一覧UseCase
- [ ] `test/usecases/users/` - UseCaseテスト
- [ ] `app/controllers/users_controller.rb` - コントローラー更新
- [ ] `app/controllers/sessions_controller.rb` - セッションコントローラー更新
- [ ] `app/helpers/sessions_helper.rb` - ヘルパー更新
- [ ] 検証: ユーザー登録・ログイン・編集が正常動作
- [ ] 統合テスト通過確認

### Phase 4: 最適化と完成 ⏳ 未着手
- [ ] `app/models/user.rb` - Active Recordモデル簡素化
- [ ] `app/models/micropost.rb` - Active Recordモデル簡素化
- [ ] `app/models/relationship.rb` - Active Recordモデル簡素化
- [ ] `config/initializers/dependencies.rb` - DIコンテナ作成（オプション）
- [ ] パフォーマンステスト・最適化
- [ ] N+1クエリ解消
- [ ] キャッシング戦略実装
- [ ] アーキテクチャドキュメント作成
- [ ] ドメインモデル図作成
- [ ] 開発ガイド作成
- [ ] 全テスト通過確認
- [ ] パフォーマンス検証

## 次のステップ

1. Phase 0の実装（基盤整備）
2. Phase 1の実装（Micropost移行）
3. 動作確認とフィードバック
4. Phase 2以降に進む

---

**総見積もり時間**: 8-12週間
**最初のマイルストーン**: Phase 1完了（2-3週間後）
**計画作成日**: 2026-01-30
