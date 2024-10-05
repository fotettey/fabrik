ui = true

listener "tcp" {
  address          = "0.0.0.0:8200"
  tls_disable      = "false"
  tls_disable_client_certs = "true"
  // tls_require_and_verify_client_cert="true"
  // tls_cert_file = "/vault/certs/wildcard/wildcard.crt"
  tls_cert_file = "/vault/certs/wildcard/wildcard-fullchain.crt"
  //tls_cert_file = "/vault/certs/server/local.self.cert-bundle.crt"
  tls_key_file  = "/vault/certs/wildcard/wildcard.key"
  # This is the certificate that client certs are signed with.  In this demo
  # the same intermediate cert signs both Vault and Client certs.  But 
  # to show this differentiation, we use the ca out of the /client-certs/ dir
  # tls_client_ca_file="/vault/file/certs/server/client-certs/ca.pem"
}

api_addr="https://127.0.0.1:8200"

storage "file" {
  path = "/vault/file"
}