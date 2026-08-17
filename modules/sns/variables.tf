variable "security_email" {
  description = "Security Team Email"
  type        = string
}

variable "kms_key_arn" {
  description = "KMS Key ARN used to encrypt the SNS topic"
  type        = string
}