resource "aws_s3_bucket" "static_assets" {
  bucket = "${var.env}-static-assets-kamilekbeznosa"

  tags = {
    Name = "${var.env}-static-assets"
  }
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.static_assets.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "public_read" {
  bucket = aws_s3_bucket.static_assets.id
  policy = data.aws_iam_policy_document.public_read.json

  depends_on = [aws_s3_bucket_public_access_block.public_access]
}

data "aws_iam_policy_document" "public_read" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.static_assets.arn}/*"]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}