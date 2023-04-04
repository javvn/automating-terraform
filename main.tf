resource "local_file" "foo" {
  count = 2
  
  content  = "foo ${count.index} ! "
  filename = "${path.module}/foo${count.index}.bar"
}