locals {
  context = yamldecode(file(var.config_file))

  provider = {
    github = merge(local.context.provider.github, {
      token = file(var.github_token_file)
    })
  }

  resource_context = {
    local_file = { for k, v in local.context.local_file : k => merge(v, {
      content = jsonencode(v.content)
    }) }
    github_actions = { for k, v in local.context.github_actions : k => v }
  }

  data_context = {
    local_file = { for k, v in local.context.data.local_file : k => v }
  }

  outputs = {
    local_file      = { for k, v in local_file.this : k => v.filename }
    data_local_file = { for k, v in data.local_file.this : k => v.filename }
  }
}