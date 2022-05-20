#!/bin/sh
set -o xtrace

#create namespace development
vault namespace create development


vault policy write -namespace=development development dev-admin.hcl


#enable userpass under namespace development
vault auth enable -namespace=development userpass

vault write -namespace=development \
        auth/userpass/users/bob password=secret


#Create an entity for Bob Smith with development policy attached. Save the generated entity ID in a file named entity_id.txt.
vault write -namespace=development -format=json identity/entity name="Bob Smith" \
        policies="development" | jq -r ".data.id" > entity_id.txt

#Get the mount accessor for userpass auth method and save it in accessor.txt.
vault auth list -namespace=development -format=json \
        | jq -r '.["userpass/"].accessor' > accessor.txt

#Create an entity alias for Bob Smith to attach bob
vault write -namespace=development identity/entity-alias name="bob" \
        canonical_id=$(cat entity_id.txt) mount_accessor=$(cat accessor.txt)


#Test BoB Smith Entity 
vault login -namespace=development -method=userpass \
        username="bob" password="secret"

echo "Log in in UI and test if Bob can create namespace or enable Secret Engines"

#Add some more aliases for Entity Bob