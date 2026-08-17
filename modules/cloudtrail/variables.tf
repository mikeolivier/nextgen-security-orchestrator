variable "lambda_arn" {
  description = "Lambda function ARN"
  type        = string
}

variable "lambda_function_name" {
  description = "Lambda function name"
  type        = string
}

variable "kms_key_arn" {
  description = "KMS key ARN used to encrypt CloudTrail logs"
  type        = string
}