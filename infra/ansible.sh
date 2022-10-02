#!/bin/sh

# 実行コマンド sh infra/ansible.sh dev portal

# 環境名 dev, prod, default
echo $1

# デプロイ先 portal, public
echo $2

ansible-playbook infra/wordpress/setting-$2.yml -i infra/wordpress/secret/$1/host --private-key=infra/wordpress/secret/conoha_ssh.pem --extra-vars="@infra/wordpress/secret/$1/$1-config.yml"