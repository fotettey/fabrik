#!/bin/sh

set -ex

VAULT_FQDN=vault.local.self
VAULT_CACERT=/vault/certs/intCA/ca-chain.crt


unseal () {
vault operator unseal -tls-server-name=$VAULT_FQDN -ca-cert=$VAULT_CACERT $(grep 'Key 1:' /vault/file/keys | awk '{print $NF}')
vault operator unseal -tls-server-name=$VAULT_FQDN -ca-cert=$VAULT_CACERT $(grep 'Key 2:' /vault/file/keys | awk '{print $NF}')
vault operator unseal -tls-server-name=$VAULT_FQDN -ca-cert=$VAULT_CACERT $(grep 'Key 3:' /vault/file/keys | awk '{print $NF}')
}

init () {
vault operator init -tls-server-name=$VAULT_FQDN -ca-cert=$VAULT_CACERT > /vault/file/keys
}

log_in () {
   export ROOT_TOKEN=$(grep 'Initial Root Token:' /vault/file/keys | awk '{print $NF}')
   vault login -tls-server-name=$VAULT_FQDN -ca-cert=$VAULT_CACERT $ROOT_TOKEN
}

create_token () {
   vault token create -tls-server-name=$VAULT_FQDN -ca-cert=$VAULT_CACERT -id $MY_VAULT_TOKEN
}

if [ -s /vault/file/keys ]; then
   unseal
else
   init
   unseal
   log_in
   create_token
fi

vault status -tls-server-name=$VAULT_FQDN -ca-cert=$VAULT_CACERT > /vault/file/status