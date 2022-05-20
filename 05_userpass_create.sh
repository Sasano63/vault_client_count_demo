#!/bin/sh
set -o xtrace
export VAULT_ADDR=http://localhost:8200
export VAULT_TOKEN=root
export VAULT_NAMESPACE=

#enable userpass to create an authentication method for creating and login
vault auth enable userpass

vault write auth/userpass/users/amar \
    password=secret

vault write auth/userpass/users/mark \
    password=secret
 
vault write auth/userpass/users/farid \
    password=secret


#List Users with entity
#curl -s --header "X-Vault-Token: root" --request LIST http://localhost:8200/v1/identity/entity/id | jq ".data.key_info"