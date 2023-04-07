locals {
  context = yamldecode(file(var.config_file))
}