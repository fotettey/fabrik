# Creating an internal Vault IntermediateCA with an Offline RootCA
## https://developer.hashicorp.com/vault/tutorials/secrets-management/pki-engine-external-ca

resource "vault_mount" "ogd_pki_int_ca_v1" {
 path                      = "ogd_pki_int_ca/v1"
 type                      = "pki"
 description               = "PKI engine hosting intermediate CA1 v1 for OGD"
 default_lease_ttl_seconds = local.default_1hr_in_sec
 max_lease_ttl_seconds     = local.default_3y_in_sec
}

resource "vault_pki_secret_backend_intermediate_cert_request" "ogd_pki_int_ca_v1" {
 depends_on   = [vault_mount.ogd_pki_int_ca_v1]
 backend      = vault_mount.ogd_pki_int_ca_v1.path
 type         = "internal"
 common_name  = "Festus-Self INT CA - CertManager"
 key_type     = "rsa"
 key_bits     = "4096"
 ou           = "DevOps"
 organization = "Festus-Self"
 country      = "DE"
 locality     = "BER"
 province     = "BER"
  #postal_code = "BER"

}

# output "intermediateca_csr" {
#   value = vault_pki_secret_backend_intermediate_cert_request.ogd_pki_int_ca_v1.csr
#   description = "CSR of intCA"
# }


## Manual Step from official VAULT docs:

## terraform show -json | jq '.values["root_module"]["resources"][].values.csr' -r | grep -v null > csr/Test_Org_v1_ICA1_v1.csr
resource "local_file" "certificate" {
    content  = vault_pki_secret_backend_intermediate_cert_request.ogd_pki_int_ca_v1.csr
    filename = "${path.cwd}/csr/intca-TF.csr"
}


## Simulates/example of how the EXTERNAL-CA can be used to sign the INTCA-CSR
# Docs: https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/locally_signed_cert
resource "tls_locally_signed_cert" "pki_int_ca" {
  cert_request_pem   = vault_pki_secret_backend_intermediate_cert_request.ogd_pki_int_ca_v1.csr
  ca_private_key_pem = file("rootCA/decrypted-rootCA.key")
  ca_cert_pem        = file("rootCA/rootCA.crt")

  validity_period_hours = 8766   #1year equivalent
  is_ca_certificate = true

  allowed_uses = [
    "digital_signature",
    "server_auth", "cert_signing", "any_extended",
    "crl_signing", 
  ]
}

resource "local_file" "pki_int_ca_cert" {
    content  = tls_locally_signed_cert.pki_int_ca.cert_pem
    filename = "${path.cwd}/pki_int_ca/Intermediate_CA1_v1.crt"
}

# Generate and bundle the intermediate and root CA certificates
#resource "terraform_data" "pki_int_ca_crt_bundled" {
#  provisioner "local-exec" {
#    command = "cat pki_int_ca/Intermediate_CA1_v1.crt rootCA/rootCA.crt > pki_int_ca/Bundled_Intermediate_CA1_v1.crt"
#    working_dir = "${path.cwd}"
#  }
#}
#
