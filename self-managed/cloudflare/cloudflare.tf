terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
      version = "~> 4"
    }
  }
}
provider "cloudflare" {
  api_token = var.api_token
}

variable "zone_id" {
  default = ""
}

variable "api_token" {
  default = ""
}

variable "account_id" {
  default = ""
}

variable "domain" {
  default = "cnap.network"
}

resource "cloudflare_record" "www" {
  zone_id = var.zone_id
  name    = "terraform"
  value   = "203.0.113.10"
  type    = "A"
  proxied = true
}
