# /tdd コマンド

TDDワークフローを開始する。

## 使い方

```
/tdd [機能名または説明]
```

## 例

```
/tdd ユーザー削除機能
/tdd パスワードリセット
/tdd マイクロポストの画像添付
```

## 動作

1. 対象のテストファイルを特定または作成
2. 失敗するテストを作成（Red）
3. テストを通す実装を行う（Green）
4. コードを改善する（Refactor）

## テストの種類

- モデルテスト: `test/models/`
- コントローラーテスト: `test/controllers/`
- 統合テスト: `test/integration/`

## テスト実行コマンド

```bash
rails test                           # 全テスト
rails test:models                    # モデルのみ
rails test test/models/user_test.rb  # 特定ファイル
rails test test/models/user_test.rb:10  # 特定行
```
