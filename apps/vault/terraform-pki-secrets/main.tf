terraform {
  required_providers {
    vault = {
      source = "hashicorp/vault"
      version = "4.2.0"
    }
  }
}

provider "vault" {
  # Configuration options
  address = var.vault_addr
  token = var.vault_token
}

#variable login_username {}
#variable login_password {}
#
#provider "vault" {
#  auth_login {
#    path = "auth/userpass/login/${var.login_username}"
#
#    parameters = {
#      password = var.login_password
#    }
#  }
#}
#

locals {
 default_3y_in_sec   = 94608000
 default_1y_in_sec   = 31536000
 default_1hr_in_sec = 3600
}

variable vault_addr {}
variable vault_token {}

