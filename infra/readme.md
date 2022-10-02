# 環境構築

ubuntu 20.04 基準として作成している。
サーバー設定には ansible を使用する。ansible はデプロイ元 PC にインストールしてください。

## サーバー設定

infra/wordpress/secret/dev-config.yml 　に設定内容を配置して実行すること。また、サーバーに対するパスワード等の設定は、sample の prod-config 等を参考に作成してください。
開発環境などのデプロイ先は、必要であれば担当者に問い合わせください。

## 環境構築スクリプト

スクリプトは、
infra/wordpress/
配下に格納されています。各スクリプトの説明は以下となります

- setting-default.yml
  - デフォルトの設定ファイル。ライブラリ等インストールする。初回実行
- setting-portal.yml
  - portal サイトの環境を構築する。
  - wordpress マルチサイトの設定も入る。
- setting-portal.yml
  - 広報サイト向けの nginx 設定を行います。

## ポータルサイトのデプロイ例

```
ansible-playbook infra/wordpress/setting-portal.yml -i infra/wordpress/secret/dev/host --private-key=infra/wordpress/secret/conoha_ssh.pem --extra-vars="@infra/wordpress/secret/dev/dev-config.yml"
```

実行後、設定ファイルの記載されたサーバーに反映されます。

## 広報サイトの設定

```
ansible-playbook infra/wordpress/setting-public.yml -i infra/wordpress/secret/dev/host --private-key=infra/wordpress/secret/conoha_ssh.pem --extra-vars="@infra/wordpress/secret/dev/dev-config.yml"
```

## 証明書発行

certbot をインストール後以下のコマンドを実行する。コマンドは、ansible 上からは実行不可
（certbot の version が古いと適用されないので注意）
また、ワイルドカード証明書は自動実行できないため、手動で実行しています。

下記の記事を参考にして DNS に設定を行ってください。
https://ichitaso.com/wordpress/wildcard-ssl-with-kusanagi-conoha/
DNS TXT が表示されるので、使用している vps の管理コンソール内で対応してください。

```
sudo certbot certonly --preferred-challenges dns-01 --authenticator manual --domain *.party-.com --domain party-.com --agree-tos --manual-public-ip-logging-ok --email hosokawamk2@gmail.com
```

## 証明書更新 cron 化

※現在まだ動きません

```
crontab -u root -e
```

cron 実行は毎 21 日とする

```
00 00 21 * * certbot renew && /etc/init.d/nginx restart
```

# 開発用コマンド

## mysql への接続方法

### 接続

```
mysql -u root -p
```

### エクスポート

```
mysqldump -u {{user}} -p {{password}} {{dbname}} > dump.sql
```

### インポート

```
mysql -u {{user}} -p {{dbname}} < dump.sql
```

# nginx

## ログ場所

```
/var/log/nginx/error.log
```

## 翻訳ファイル生成

※基本的には plugin 内部において実行します。

```
msgfmt src/wp-content/themes/kleo-child/languages/ja.po -o src/wp-content/themes/kleo-child/languages/ja.mo
```
