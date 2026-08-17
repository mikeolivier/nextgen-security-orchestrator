data "aws_caller_identity" "current" {}

resource "aws_kms_key" "company_key" {
  description             = "Customer Managed Key for NextGen Security"
  deletion_window_in_days = 30
  enable_key_rotation     = true

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [

      {
        Sid    = "EnableRootPermissions"
        Effect = "Allow"

        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }

        Action   = "kms:*"
        Resource = "*"
      },

      {
        Sid    = "AllowCloudTrail"
        Effect = "Allow"

        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }

        Action = [
          "kms:GenerateDataKey*",
          "kms:Decrypt",
          "kms:DescribeKey"
        ]

        Resource = "*"
      }
    ]
  })

  tags = {
    Name    = "${var.project_name}-kms-key"
    Project = var.project_name
  }
}