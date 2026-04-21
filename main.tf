resource "aws_s3_bucket" "media_ingest" {
  bucket = "media-pipeline-ingest-dtaylor-2026" # Change this to be unique
}

resource "aws_dynamodb_table" "media_metadata" {
  name         = "MediaMetadata"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "FileName"

  attribute {
    name = "FileName"
    type = "S"
  }
}