#!/bin/sh
set -o xtrace

#create token with default policy
vault token create -policy="default" -period=1h -format=json \
   | jq -r ".auth.client_token" > periodic_token1.txt

vault token create -policy="default" -period=1h -format=json \
   | jq -r ".auth.client_token" > periodic_token2.txt

vault token create -policy="default" -period=1h -format=json \
   | jq -r ".auth.client_token" > periodic_token3.txt

vault token create -orphan -policy="default" -period=1h -format=json \
   | jq -r ".auth.client_token" > orphan_token.txt


sleep 2
echo "Log in with each of this tokens!"

sleep 2
echo "Check Vault UI Client count - only 1 Non-Entity token counts"