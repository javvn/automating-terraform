locals {
  context = yamldecode(file(var.config_file))

  resource_context = {
    local_file = local.context.local_file
  }
}