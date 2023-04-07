resource "local_file" "this" {
  for_each = local.context.local_file
  
  content  = each.value.content
  filename = each.value.filename
}