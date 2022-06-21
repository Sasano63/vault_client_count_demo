#!/bin/sh
set -o xtrace
export VAULT_ADDR=http://localhost:8200
export VAULT_TOKEN=root
#create namespace development
vault namespace create development


vault policy write -namespace=development development dev-admin.hcl


#enable userpass under namespace development
vault auth enable -namespace=development userpass

vault write -namespace=development \
        auth/userpass/users/alices password=geheim



# Create an entity for Alice with development policy attached. Save the generated entity ID in a file named entity_id.txt.
vault write -namespace=development -format=json identity/entity name="Alice Schmidt" \
        policies="developer" | jq -r ".data.id" > entity_id.txt

# Get the mount accessor for userpass auth method and save it in accessor_development.txt
vault auth list -namespace=development -format=json \
        | jq -r '.["userpass/"].accessor' > accessor_development.txt

# Create an entity alias for Alice to attach alices
vault write -namespace=development identity/entity-alias name="alices" \
        canonical_id=$(cat entity_id.txt) mount_accessor=$(cat accessor_development.txt)


#Test Alice Schmidt Entity 
# vault login -namespace=development -method=userpass \
#         username="alices" password="geheim"

# echo "Log in in UI and test if Alice can create namespace or enable Secret Engines"

#Add some more aliases for Entity Alice