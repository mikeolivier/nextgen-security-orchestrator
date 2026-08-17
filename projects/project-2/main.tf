module "kms" {
  source = "../../modules/kms"

  project_name = "nextgen-security"
}


module "s3" {
  source = "../../modules/s3"

  bucket_name = "nextgen-${random_string.bucket_suffix.result}"
  kms_key_arn = module.kms.kms_key_arn
}



module "secrets" {
  source = "../../modules/secrets-manager"

  secret_name  = "database-password"
  secret_value = "SuperSecurePassword123!"

  kms_key_id = module.kms.kms_key_id
}


resource "random_string" "bucket_suffix" {
  length  = 8
  upper   = false
  special = false
}



resource "random_string" "config_bucket_suffix" {
  length  = 8
  upper   = false
  special = false
}

module "config" {
  source = "../../modules/config"

  bucket_name = "nextgen-config-${random_string.config_bucket_suffix.result}"
}


#guarduty
module "guardduty" {
  source = "../../modules/guardduty"
}


#security Hub
module "securityhub" {
  source = "../../modules/securityhub"
}