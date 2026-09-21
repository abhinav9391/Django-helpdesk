# ============================================================
# S3 BUCKET - APPLICATION ARTIFACTS
# ============================================================

resource "aws_s3_bucket" "artifacts" {
  bucket = "django-helpdesk-poc-artifacts-593760773720"

  tags = {
    Name = "django-helpdesk-poc-artifacts"
  }
}


# ============================================================
# BLOCK PUBLIC ACCESS
# ============================================================

resource "aws_s3_bucket_public_access_block" "artifacts" {
  bucket = aws_s3_bucket.artifacts.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


# ============================================================
# ENABLE VERSIONING
# ============================================================

resource "aws_s3_bucket_versioning" "artifacts" {
  bucket = aws_s3_bucket.artifacts.id

  versioning_configuration {
    status = "Enabled"
  }
}