
resource "tfe_organization_token" "this" {
  organization = local.context.tfe.org_token.org
}

resource "github_actions_secret" "this" {
  for_each = local.context.github_actions.env_secret

  repository      = each.value.repository
  secret_name     = each.value.secret_name
  plaintext_value = tfe_organization_token.this.token
}