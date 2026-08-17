resource "aws_kms_key" "company_key" {
  description             = "Customer Managed Key for Project 2"
  deletion_window_in_days = 30
  enable_key_rotation     = true

  tags = {
    Name    = "${var.project_name}-kms-key"
    Project = var.project_name
  }
}