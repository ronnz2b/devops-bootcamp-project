provider "aws" {
  region = "ap-southeast-1"
}

# Terraform state S3 bucket
resource "aws_s3_bucket" "terraform_state" {
  bucket = "devops-bootcamp-terraform-azrai"

  tags = {
    Name        = "terraform-state"
    Environment = "devops-bootcamp"
  }
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
