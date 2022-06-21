#!/bin/sh
set -o xtrace

#set VAULT_LICENSE
export VAULT_LICENSE=`cat ../../vault.hclic`

#stop and remove vault containers if already running
docker stop vault-demo-vault
docker rm vault-demo-vault
#start Vault in dev mode on port 8200
docker network create dev-network
docker run --name vault-demo-vault --network dev-network -p 8200:8200 -e VAULT_LICENSE="${VAULT_LICENSE}" hashicorp/vault-enterprise:1.10.0-ent server -dev -dev-root-token-id="root" &

sleep 5

export VAULT_ADDR='http://0.0.0.0:8200'
export VAULT_TOKEN=root