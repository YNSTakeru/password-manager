# パスワードマネージャー

パスワードを管理するシェルスクリプトです。
下記 3 種類の情報を保存、取得します。

- サービス名
- ユーザ名
- パスワード

## 使い方

```bash
# 実行権限を与えてください
chmod +x ./password_manager.sh
./password_manager.sh
```

## 注意事項

1. 本スクリプトは `OpenSSL 3.2.0 23 Nov 2023` を利用しています。利用する場合は上記バージョンをインストールしてください

2. `./password_manager.sh`を実行すると共通鍵`shared.aeskey`が`./password_manager.sh`と同一階層に作成されます。この共通鍵を外部に漏洩しないでください。万一漏洩した場合は、登録している情報をバックアップした上で、共通鍵` shared.aeskey`と`password_manger_database.dat.enc `を削除して再度`./password_manager.sh`を実行し再度共通鍵を作成してください。

3. 本スクリプトは`サービス名`、`ユーザー名`、`パスワード`に`:`を含めて登録すると正しく動作しません。ご注意ください。

## 検証環境

- Mac Intel Core
  - macOS 14.1.2
