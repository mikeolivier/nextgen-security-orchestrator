resource "aws_cloudwatch_event_rule" "guardduty_findings" {
  name        = "guardduty-findings"
  description = "Route GuardDuty findings"

  event_pattern = jsonencode({
    source = ["aws.guardduty"]

    detail-type = [
      "GuardDuty Finding"
    ]
  })
}

resource "aws_cloudwatch_event_target" "lambda" {
  rule = aws_cloudwatch_event_rule.guardduty_findings.name
  arn  = var.lambda_arn
}


#Allow EventBridge to invoke Lambda

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowGuardDutyEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.guardduty_findings.arn
}


resource "aws_cloudwatch_event_target" "sns" {
  rule = aws_cloudwatch_event_rule.guardduty_findings.name
  arn  = var.sns_topic_arn
}