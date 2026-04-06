resource "aws_s3_bucket" "bucket" {
  bucket        = "${var.project_name}-terraform-bucket"
  force_destroy = true

  tags = {
    Name    = "${var.project_name}-terraform-bucket"
    project = "${var.project_name}"
  }
}

resource "aws_s3_bucket_versioning" "bucket" {
  bucket = aws_s3_bucket.bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "bucket" {
  bucket = aws_s3_bucket.bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
