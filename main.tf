resource "local_file" "foo" {
  count = 3
  
  content  = "foo ${count.index} ! "
  filename = "${path.module}/foo${count.index}.bar"
}