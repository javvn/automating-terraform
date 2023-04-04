output "tfe_org_token" {
  value     = tfe_organization_token.this
  sensitive = true
}

output "github_actions_secret" {
  value     = github_actions_secret.this
  sensitive = true
}