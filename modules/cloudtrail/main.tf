data "aws_caller_identity" "current" {}

# Secure S3 bucket for long-term CloudTrail logs
resource "aws_s3_bucket" "trail_logs" {
  bucket        = "nextgen-cloudtrail-logs-${data.aws_caller_identity.current.account_id}"
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "trail_logs" {
  bucket = aws_s3_bucket.trail_logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "cloudtrail" {
  bucket = aws_s3_bucket.trail_logs.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AWSCloudTrailAclCheck"
        Effect    = "Allow"
        Principal = { Service = "cloudtrail.amazonaws.com" }
        Action    = "s3:GetBucketAcl"
        Resource  = aws_s3_bucket.trail_logs.arn
      },
      {
        Sid       = "AWSCloudTrailWrite"
        Effect    = "Allow"
        Principal = { Service = "cloudtrail.amazonaws.com" }
        Action    = "s3:PutObject"
        Resource  = "${aws_s3_bucket.trail_logs.arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"

        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          }
        }
      }
    ]
  })
}

# CloudWatch Logs group for near-real-time monitoring
resource "aws_cloudwatch_log_group" "cloudtrail_logs" {
  name              = "/aws/cloudtrail/iam-security"
  retention_in_days = 30
}

# Role CloudTrail uses to write to CloudWatch Logs
resource "aws_iam_role" "cloudtrail_logs_role" {
  name = "CloudTrail-CloudWatch-Logs-Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "cloudtrail.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "cloudtrail_logs_policy" {
  name = "Allow-CloudTrail-Write-Logs"
  role = aws_iam_role.cloudtrail_logs_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
      Resource = "${aws_cloudwatch_log_group.cloudtrail_logs.arn}:*"
    }]
  })
}

# Multi-Region trail collecting global IAM events
resource "aws_cloudtrail" "security_trail" {
  name                          = "NextGen-Security-Trail"
  s3_bucket_name                = aws_s3_bucket.trail_logs.id
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_logging                = true
  enable_log_file_validation    = true
  kms_key_id = var.kms_key_arn

  cloud_watch_logs_group_arn = "${aws_cloudwatch_log_group.cloudtrail_logs.arn}:*"
  cloud_watch_logs_role_arn  = aws_iam_role.cloudtrail_logs_role.arn

  event_selector {
    include_management_events = true
    read_write_type           = "All"
  }

  depends_on = [
    aws_s3_bucket_policy.cloudtrail,
    aws_iam_role_policy.cloudtrail_logs_policy
  ]
}

# Allow CloudWatch Logs to invoke Lambda
resource "aws_lambda_permission" "allow_cloudwatch_logs" {
  statement_id  = "AllowExecutionFromCloudWatchLogs"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "logs.ca-central-1.amazonaws.com"
  source_arn    = "${aws_cloudwatch_log_group.cloudtrail_logs.arn}:*"
}

# Send only CreateAccessKey events to Lambda
resource "aws_cloudwatch_log_subscription_filter" "iam_access_key" {
  name            = "Detect-IAM-Access-Key-Creation"
  log_group_name  = aws_cloudwatch_log_group.cloudtrail_logs.name
  destination_arn = var.lambda_arn

  filter_pattern = "{ ($.eventSource = \"iam.amazonaws.com\") && ($.eventName = \"CreateAccessKey\") }"

  depends_on = [
    aws_lambda_permission.allow_cloudwatch_logs
  ]
}