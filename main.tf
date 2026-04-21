# 1. Storage & Database
resource "aws_s3_bucket" "media_ingest" {
  bucket = "media-pipeline-ingest-dtaylor-2026" # Ensure this is unique
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

# 2. Lambda Code Packaging
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/../lambda-functions/process_media.py"
  output_path = "${path.module}/lambda_function.zip"
}

# 3. Permissions (IAM)
resource "aws_iam_role" "lambda_role" {
  name = "media_pipeline_lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "rekognition_access" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRekognitionFullAccess"
}

resource "aws_iam_role_policy_attachment" "dynamo_access" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

# 4. The Lambda Function
resource "aws_lambda_function" "media_processor" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = "ProcessMediaFunction"
  role             = aws_iam_role.lambda_role.arn
  handler          = "process_media.lambda_handler"
  runtime          = "python3.9"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
}

# 5. The Trigger (S3 -> Lambda)
resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.media_processor.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.media_ingest.arn
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.media_ingest.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.media_processor.arn
    events              = ["s3:ObjectCreated:*"]
  }
  depends_on = [aws_lambda_permission.allow_s3]
}