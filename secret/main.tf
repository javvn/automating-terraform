resource "local_file" "this" {
  for_each = local.resource_context.local_file

  content  = each.value.content
  filename = each.value.filename
}

resource "null_resource" "tfe_token_payload" {
  triggers = {
    file_name = local_file.this["tfe_token_payload"].filename
  }

  provisioner "local-exec" {
    command = "sh scripts/tfe-token-run.sh create"
  }

  provisioner "local-exec" {
    when       = destroy
    on_failure = continue
    command    = "sh scripts/tfe-token-run.sh remove"
  }
}

data "local_file" "this" {
  for_each = local.data_context.local_file
  filename = each.value.filename

  depends_on = [
    null_resource.tfe_token_payload
  ]
}

resource "github_actions_secret" "this" {
  for_each = local.resource_context.github_actions.secret

  repository      = each.value.repository
  secret_name     = each.value.secret_name
  plaintext_value = data.local_file.this[each.key].content
}