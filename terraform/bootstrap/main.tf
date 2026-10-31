provider "aws" {
  region = "ap-northeast-1"

  default_tags {
    tags = {
      Project = "kago"
    }
  }
}

resource "aws_s3_bucket" "tfstate" {
  bucket           = "kago-tfstate-441541653503-ap-northeast-1-an"
  bucket_namespace = "account-regional"

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
