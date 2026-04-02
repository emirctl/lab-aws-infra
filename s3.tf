resource "random_id" "bucket_suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "lab_bucket" {
  bucket = "${var.project_name}-storage-${random_id.bucket_suffix.hex}"
  tags   = { Name = "Lab Storage" }
}
