##  Import externally signed cert for ICA1 in Vault.

resource "vault_pki_secret_backend_intermediate_set_signed" "self_pki_int_ca_v1_signed_cert" {
 depends_on   = [vault_mount.self_pki_int_ca_v1]
 backend      = vault_mount.self_pki_int_ca_v1.path

 ## Reference the signed and received INT_CA CRT from CertProvider:
  # certificate = tls_locally_signed_cert.pki_int_ca.cert_pem
 certificate = local_file.pki_int_ca_cert.content

}