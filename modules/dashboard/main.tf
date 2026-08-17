

resource "aws_cloudwatch_dashboard" "soc_dashboard" {

  dashboard_name = "NextGen-SOC"

  dashboard_body = jsonencode({

    widgets = [

      {
        type = "text"

        x = 0
        y = 0

        width = 24
        height = 3

        properties = {

          markdown = <<EOF
# 🛡️ NextGen Security Operations Center

## Enterprise Cloud Security Dashboard

This dashboard provides real-time visibility into the Security Operations Platform.
EOF

        }

      }

    ]

  })

}