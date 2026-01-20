terraform {
  backend "s3" {
    bucket  = "devops-bootcamp-terraform-azrai"
    key     = "terraform/terraform.tfstate"
    region  = "ap-southeast-1"
    encrypt = true
  }
}
