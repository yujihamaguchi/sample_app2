# /debug コマンド

デバッグを支援する。

## 使い方

```
/debug [エラーメッセージまたは問題の説明]
```

## 例

```
/debug NoMethodError: undefined method 'name' for nil:NilClass
/debug ログインができない
/debug マイクロポストが表示されない
```

## 動作

1. エラーメッセージを分析
2. 関連するコードを調査
3. 原因を特定
4. 解決策を提案

## デバッグ手法

- ログ確認（log/development.log）
- Rails Console
- デバッガー（debugger）
- ビューでのdebug出力
