

resource "aws_iam_user" "this" {
  name = var.user_name
}


#Create an IAM Group
resource "aws_iam_group" "security_team" {
  name = "Security-Team"
}

# security team group policy
resource "aws_iam_group_policy_attachment" "readonly" {
  group      = aws_iam_group.security_team.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

#IAM Role named Security-Engineer-Role & the a Policy

resource "aws_iam_role" "security_engineer_role" {
  name = "Security-Engineer-Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        AWS = "*"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "readonly" {
  role       = aws_iam_role.security_engineer_role.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}
