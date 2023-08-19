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


resource "cloudflare_ruleset" "zone_level_http_ddos_config" {
  zone_id     = var.zone_id
  name        = "HTTP DDoS Attack Protection entry point ruleset"
  description = ""
  kind        = "zone"
  phase       = "ddos_l7"

  rules {
    action = "execute"
    action_parameters {
      id = "4d21379b4f9f4bb088e0729962c8b3cf"
      overrides {
        rules {
          # Rule: HTTP requests with unusual HTTP headers or URI path (signature #11).
          id = "fdfdac75430c4c47a959592f0aa5e68a"
          sensitivity_level = "low"
        }
      }
    }
    expression = "true"
    description = "Override the HTTP DDoS Attack Protection managed ruleset"
    enabled = true
  }
}
