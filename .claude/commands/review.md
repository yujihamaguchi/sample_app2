# /review コマンド

コードレビューを実行する。

## 使い方

```
/review [ファイルパスまたはパターン]
```

## 例

```
/review app/models/user.rb
/review app/controllers/
/review test/integration/
```

## 動作

1. 指定されたファイルまたはディレクトリのコードを読み込む
2. code-reviewerエージェントの観点に基づいてレビューを実施
3. 良い点と改善提案を出力

## レビュー観点

- Rails規約（命名、ディレクトリ構成、RESTful）
- モデル層（バリデーション、関連付け）
- コントローラー層（before_action、Strong Parameters）
- テスト（カバレッジ、フィクスチャ）
