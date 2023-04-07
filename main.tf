resource "local_file" "foo" {
  for_each = local.resource_context.local_file

  content  = each.value.content
  filename = each.value.filename
}