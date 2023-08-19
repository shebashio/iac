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

resource "cloudflare_ruleset" "account_level_managed_waf" {
  # Execute Cloudflare OWASP Core Ruleset
  rules {
    action = "execute"
    action_parameters {
      id = "4814384a9e5d4991b9815dcfc25d2f1f"
      overrides {
        # By default, all PL1 to PL4 rules are enabled.
        # Set the paranoia level to PL2 by disabling rules with
        # tags "paranoia-level-3" and "paranoia-level-4".
        categories {
          category = "paranoia-level-3"
          status = "disabled"
        }
        categories {
          category = "paranoia-level-4"
          status = "disabled"
        }
        rules {
          id = "6179ae15870a4bb7b2d480d4843b323c"
          action = "log"
          score_threshold = 60
        }
      }
    }
    expression = "true"
    description = "zone"
    enabled = true
  }
}
