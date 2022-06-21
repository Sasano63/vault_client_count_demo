#!/bin/sh
set -o xtrace
export VAULT_ADDR=http://localhost:8200
export VAULT_TOKEN=root

#Write two more policies
vault policy write developer -<<EOF
path "secret/data/training_*" {
   capabilities = ["create", "read"]
}
EOF

vault write auth/userpass/users/alice \
    password="geheim"

# Userpass-Test
vault auth enable -path="userpass-test" userpass

vault write auth/userpass-test/users/alices password="geheim" policies="test"


# Create Identity bob-smith
vault auth list -format=json | jq -r '.["userpass-test/"].accessor' > accessor_test.txt

vault auth list -format=json | jq -r '.["userpass/"].accessor' > accessor.txt

vault write -format=json identity/entity name="alice-schmidt" policies="developer" \
     metadata=organization="HashiCups" \
     metadata=team="Dev" \
     | jq -r ".data.id" > entity_id.txt

vault write identity/entity-alias name="alice" \
     canonical_id=$(cat entity_id.txt) \
     mount_accessor=$(cat accessor.txt) \
     custom_metadata=account="Dev Account"

vault write identity/entity-alias name="alices" \
     canonical_id=$(cat entity_id.txt) \
     mount_accessor=$(cat accessor_test.txt) \
     custom_metadata=account="Tester Account"


# vault login -format=json -method=userpass -path=userpass-test \
#     username=bob password=training \
#     | jq -r ".auth.client_token" > bob_token.txt

