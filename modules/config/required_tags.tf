

resource "aws_config_config_rule" "required_tags" {

  name = "required-tags"

  source {
    owner             = "AWS"
    source_identifier = "REQUIRED_TAGS"
  }

  scope {
    compliance_resource_types = [
      "AWS::EC2::Instance"
    ]
  }

  input_parameters = jsonencode({
    tag1Key = "Owner"
    tag2Key = "Environment"
    tag3Key = "Application"
    tag4Key = "CostCenter"
    tag5Key = "DataClassification"
  })

  depends_on = [
    aws_config_configuration_recorder_status.main
  ]
}