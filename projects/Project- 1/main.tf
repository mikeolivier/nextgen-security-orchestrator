module "security_user" {
  source = "../../modules/iam"

  user_name = "security-test-user"
}

#kms module
module "kms" {
  source = "../../modules/kms"

  project_name = "nextgen-security"
}

#security module

module "security_alerts" {
  source = "../../modules/sns"

  security_email = var.security_email
  kms_key_arn    = module.kms.kms_key_arn
}

module "security_lambda" {
  source = "../../modules/lambda"

  sns_topic_arn = module.security_alerts.topic_arn
}

module "cloudtrail" {
  source = "../../modules/cloudtrail"

  lambda_arn           = module.security_lambda.lambda_arn
  lambda_function_name = module.security_lambda.lambda_function_name
  kms_key_arn          = module.kms.kms_key_arn
}


module "event_router" {
  source = "../../modules/event-router"

  sns_topic_arn        = module.security_alerts.topic_arn
  lambda_arn           = module.security_lambda.lambda_arn
  lambda_function_name = module.security_lambda.lambda_function_name
}

# #darshboard
# module "logging" {
#   source = "../../modules/logging"
# }

module "dashboard" {
  source = "../../modules/dashboard"
}