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
