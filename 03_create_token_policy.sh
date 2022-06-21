#!/bin/sh
export VAULT_ADDR='http://0.0.0.0:8200'
export VAULT_TOKEN=root

set -o xtrace

vault policy write test -<<EOF
path "auth/token/create" {
   capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}
path "secret/data/test" {
   capabilities = [ "create", "read", "update", "delete" ]
}
EOF

#create token with policy test
vault token create -ttl=1h -policy=test -format=json \
    | jq -r ".auth.client_token" > token_test.txt

vault token create -ttl=1h -policy=test,default -format=json \
    | jq -r ".auth.client_token" > token_testdefault.txt



# #list vault tokens
#vault list --format json auth/token/accessors

#revoke specific token
#vault write auth/token/revoke-accessor accessor=${accessor}