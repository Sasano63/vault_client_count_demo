#!/bin/sh
set -o xtrace
#stop and remove vault containers if running
docker stop vault-demo-vault
docker rm vault-demo-vault
docker network rm dev-network

#delete all generated files
rm orphan_token.txt
rm periodic_token1.txt
rm periodic_token2.txt
rm periodic_token3.txt
rm parent_token.txt
rm child_token.txt
rm orphan_token.txt
rm entity_id.txt
rm accessor.txt
rm orphan_token2.txt