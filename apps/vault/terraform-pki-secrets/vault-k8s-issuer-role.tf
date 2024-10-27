resource "vault_pki_secret_backend_role" "vault_role" {
 backend            = vault_mount.self_pki_int_ca_v1.path
 name               = "int-ca-certmanager"
 ttl                = local.default_1hr_in_sec
 allow_ip_sans      = true
 key_type           = "rsa"
 key_bits           = 2048
 allow_any_name     = false ##check this
 allow_localhost    = true
 allowed_domains    = ["svc"]
 allow_bare_domains = false
 allow_subdomains   = true
 allow_wildcard_certificates = true
 enforce_hostnames  = true
 server_flag        = true
 client_flag        = false
 no_store           = true
 country            = ["DE"]
 province           = ["BER"]
 locality           = ["BER"]
 organization       = ["Festus-Self"]
 ou                 = ["DevOps"]
 require_cn       = false
 allowed_uri_sans   = ["spiffe://cluster.local/*"]
 key_usage = ["DigitalSignature", "KeyAgreement", "KeyEncipherment"]
 use_csr_common_name = true
 use_csr_sans = false
}

