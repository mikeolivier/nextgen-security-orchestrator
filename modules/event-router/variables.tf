variable "sns_topic_arn" {
  description = "SNS Topic ARN for security notifications"
  type        = string
}


variable "lambda_arn" {
  description = "Lambda ARN"
  type        = string
}


variable "lambda_function_name" {
  description = "Lambda function name"
  type        = string
}