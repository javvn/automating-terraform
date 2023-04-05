#output "tfe_token_payload" {
#  value = local_file.tfe_token_payload.content
#}

output "local_file" {
  value = local.outputs.local_file
}

output "data_local_file" {
  value = local.outputs.data_local_file
}

output "github_actions_secret" {
  value     = github_actions_secret.this
  sensitive = true
}