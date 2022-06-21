#!/bin/sh
set -o xtrace

export VAULT_ADDR='http://0.0.0.0:8200'
export VAULT_TOKEN=root


#create token with default policy
vault token create -policy="default" -period=1h -format=json \
   | jq -r ".auth.client_token" > periodic_token1.txt

vault token create -policy="default" -period=1h -format=json \
   | jq -r ".auth.client_token" > periodic_token2.txt

