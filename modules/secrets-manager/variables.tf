variable "secret_name" {
  description = "Name of the secret"
  type        = string
}

variable "secret_value" {
  description = "Value of the secret"
  type        = string
  sensitive   = true
}

variable "kms_key_id" {
  description = "KMS Key ID"
  type        = string
}