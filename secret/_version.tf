# https://developer.hashicorp.com/terraform/cloud-docs/users-teams-organizations/api-tokens

terraform {
  required_version = "~>1.4"

  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "2.4.0"
    }
    github = {
      source  = "integrations/github"
      version = "5.19.0"
    }
  }
}