
#Restrict Lambda permission to the EventBridge rule

output "rule_arn" {
  value = aws_cloudwatch_event_rule.access_key_created.arn
}