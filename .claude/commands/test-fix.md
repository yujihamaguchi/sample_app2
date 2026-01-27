# /test-fix コマンド

落ちたテストを修正する。

## 使い方

```
/test-fix [テストファイル:行番号 または エラーメッセージ]
```

## 例

```
/test-fix test/integration/users_login_test.rb:20
/test-fix Expected: "users/show" Actual: "sessions/new"
/test-fix 最後に落ちたテスト
```

## 動作

1. エラーメッセージを分析
2. テストコードを確認
3. 実装コードを確認
4. 原因を特定
5. 修正方法を提案

## よくある失敗パターン

- AssertionError: 期待値と実際の値の不一致
- NoMethodError: nilオブジェクトへのメソッド呼び出し
- RoutingError: ルートが見つからない
- RecordInvalid: バリデーションエラー
