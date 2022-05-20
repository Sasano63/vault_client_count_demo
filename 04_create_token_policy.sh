#!/bin/sh
set -o xtrace

vault policy write test -<<EOF
path "auth/token/create" {
   capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}
EOF

#create token with policy test
vault token create -ttl=1h -policy=test -format=json \
    | jq -r ".auth.client_token" > parent_token.txt

VAULT_TOKEN=$(cat parent_token.txt) \
   vault token create -ttl=30m -policy=default -format=json \
    | jq -r ".auth.client_token" > child_token.txt

VAULT_TOKEN=$(cat parent_token.txt) \
   vault token create -orphan -ttl=2h -policy=default -format=json \
    | jq -r ".auth.client_token" > orphan_token2.txt

sleep 2
echo "Log in with parent token"

sleep 2
echo "Check Vault UI Client count - new value non-entity-token count"


#list vault tokens
#vault list --format json auth/token/accessors

#revoke specific token
#vault write auth/token/revoke-accessor accessor=${accessor}