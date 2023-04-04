terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "jawn"

    workspaces {
      prefix = "automating-terraform-"
    }
  }
}