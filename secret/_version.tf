# https://developer.hashicorp.com/terraform/cloud-docs/users-teams-organizations/api-tokens

terraform {
  required_version = "~>1.4"

  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = "0.43.0"
    }
    github = {
      source  = "integrations/github"
      version = "5.19.0"
    }
  }
}