output "event_rule_name" {
  value = aws_cloudwatch_event_rule.guardduty_findings.name
}