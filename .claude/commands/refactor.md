# /refactor コマンド

コードのリファクタリングを行う。

## 使い方

```
/refactor [ファイルパスまたはディレクトリ]
```

## 例

```
/refactor app/controllers/users_controller.rb
/refactor app/models/
/refactor app/helpers/
```

## 動作

1. 対象コードを読み込み、現状を把握
2. テストがパスすることを確認
3. リファクタリングを実施
4. テストで動作確認

## リファクタリングの観点

- Fat Controller → Skinny Controller
- ビューロジック → ヘルパー
- 繰り返し → パーシャル
- 条件 → スコープ
- N+1クエリ → eager loading
