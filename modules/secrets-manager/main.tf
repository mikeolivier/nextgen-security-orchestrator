resource "aws_secretsmanager_secret" "database_password" {
  name       = var.secret_name
  kms_key_id = var.kms_key_id
}

resource "aws_secretsmanager_secret_version" "current" {
  secret_id     = aws_secretsmanager_secret.database_password.id
  secret_string = var.secret_value
}