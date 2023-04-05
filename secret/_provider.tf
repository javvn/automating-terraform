# https://docs.github.com/ko/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token
# https://registry.terraform.io/providers/integrations/github/latest/docs

provider "github" {
  token = local.provider.github.token
  owner = local.provider.github.owner
}