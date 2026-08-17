# Receiving event bus in Canada
resource "aws_cloudwatch_event_bus" "security_bus" {
  name = "NextGen-Security-Bus"
}

# Detect IAM CreateAccessKey in us-east-1
resource "aws_cloudwatch_event_rule" "iam_forwarder" {
  provider = aws.use1

  name        = "Forward-IAM-AccessKey-To-Canada"
  description = "Forward IAM access-key events to ca-central-1"

  event_pattern = jsonencode({
    source      = ["aws.iam"]
    detail-type = ["AWS API Call via CloudTrail"]

    detail = {
      eventSource = ["iam.amazonaws.com"]
      eventName   = ["CreateAccessKey"]
    }
  })
}

# Role allowing EventBridge to forward the event
resource "aws_iam_role" "forwarder_role" {
  name = "EventBridge-Cross-Region-Forwarder"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Effect = "Allow"

      Principal = {
        Service = "events.amazonaws.com"
      }

      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "forwarder_policy" {
  name = "Allow-PutEvents-To-Canada"
  role = aws_iam_role.forwarder_role.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Effect   = "Allow"
      Action   = "events:PutEvents"
      Resource = aws_cloudwatch_event_bus.security_bus.arn
    }]
  })
}

# Forward us-east-1 event to Canada
resource "aws_cloudwatch_event_target" "forward_to_canada" {
  provider = aws.use1

  rule     = aws_cloudwatch_event_rule.iam_forwarder.name
  target_id = "SendToCanada"
  arn       = aws_cloudwatch_event_bus.security_bus.arn
  role_arn  = aws_iam_role.forwarder_role.arn
}

# Receive and process the forwarded event in Canada
resource "aws_cloudwatch_event_rule" "access_key_created" {
  name           = "IAM-AccessKey-Created"
  event_bus_name = aws_cloudwatch_event_bus.security_bus.name

  event_pattern = jsonencode({
    source      = ["aws.iam"]
    detail-type = ["AWS API Call via CloudTrail"]

    detail = {
      eventSource = ["iam.amazonaws.com"]
      eventName   = ["CreateAccessKey"]
    }
  })
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule           = aws_cloudwatch_event_rule.access_key_created.name
  event_bus_name = aws_cloudwatch_event_bus.security_bus.name
  target_id      = "SecurityLambda"
  arn            = var.lambda_arn
}

resource "aws_cloudwatch_event_target" "sns_target" {
  rule           = aws_cloudwatch_event_rule.access_key_created.name
  event_bus_name = aws_cloudwatch_event_bus.security_bus.name
  target_id      = "SecuritySNS"
  arn            = var.sns_topic_arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.access_key_created.arn
}


data "aws_caller_identity" "current" {}

resource "aws_cloudwatch_event_bus_policy" "allow_same_account" {
  event_bus_name = aws_cloudwatch_event_bus.security_bus.name

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Sid    = "AllowCrossRegionEvents"
      Effect = "Allow"

      Principal = {
        AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      }

      Action   = "events:PutEvents"
      Resource = aws_cloudwatch_event_bus.security_bus.arn
    }]
  })
}