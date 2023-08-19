terraform {
  backend "remote" {
    organization = "shebash"

    workspaces {
      name = "cloudflare-cnap-network"
    }
  }
}
