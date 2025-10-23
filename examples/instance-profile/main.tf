module "ec2_instance_role" {
  source = "../../"

  name                  = var.instance_role_name
  description           = "IAM role for EC2 instances with Systems Manager and CloudWatch access"
  path                  = "/ec2/"
  force_detach_policies = true
  max_session_duration  = 7200 # 2 hours

  assume_role_policy = [
    {
      sid     = "EC2AssumeRole"
      effect  = "Allow"
      actions = ["sts:AssumeRole"]
      principals = [
        {
          type        = "Service"
          identifiers = ["ec2.amazonaws.com"]
        }
      ]
      conditions = var.enable_source_ip_condition ? [
        {
          test     = "IpAddress"
          variable = "aws:SourceIp"
          values   = var.allowed_source_ips
        }
      ] : []
    }
  ]

  tags = {
    Environment = var.environment
    Purpose     = "ec2-instance-profile"
    ManagedBy   = "terraform"
    Application = var.application_name
  }
}

# Create instance profile
resource "aws_iam_instance_profile" "this" {
  name = module.ec2_instance_role.role_name
  role = module.ec2_instance_role.role_name
  path = "/ec2/"

  tags = module.ec2_instance_role.role_tags
}

# Attach AWS managed policies
resource "aws_iam_role_policy_attachment" "ssm_managed_instance_core" {
  count = var.enable_ssm_access ? 1 : 0

  role       = module.ec2_instance_role.role_name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore" # pragma: allowlist secret
}

resource "aws_iam_role_policy_attachment" "cloudwatch_agent" {
  count = var.enable_cloudwatch_agent ? 1 : 0

  role       = module.ec2_instance_role.role_name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy" # pragma: allowlist secret
}

resource "aws_iam_role_policy_attachment" "s3_read_only" {
  count = var.enable_s3_read_access ? 1 : 0

  role       = module.ec2_instance_role.role_name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess" # pragma: allowlist secret
}

# Custom policy for application-specific permissions
resource "aws_iam_role_policy" "application_permissions" {
  count = var.application_name != null ? 1 : 0

  name = "${var.application_name}-permissions"
  role = module.ec2_instance_role.role_name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      for stmt in concat(
        var.enable_parameter_store_access ? [
          {
            Sid    = "ParameterStoreAccess"
            Effect = "Allow"
            Action = [
              "ssm:GetParameter",
              "ssm:GetParameters",
              "ssm:GetParametersByPath"
            ]
            Resource = [
              "arn:aws:ssm:*:*:parameter/${var.application_name}/*",
              "arn:aws:ssm:*:*:parameter/shared/*"
            ]
          }
        ] : [],
        var.enable_secrets_manager_access ? [
          {
            Sid    = "SecretsManagerAccess"
            Effect = "Allow"
            Action = [
              "secretsmanager:GetSecretValue",
              "secretsmanager:DescribeSecret"
            ]
            Resource = [
              "arn:aws:secretsmanager:*:*:secret:${var.application_name}/*",
              "arn:aws:secretsmanager:*:*:secret:shared/*"
            ]
          }
        ] : [],
        var.custom_policy_statements
        ) : {
        for k, v in stmt : k => v if v != null
      }
    ]
  })
}

# Example EC2 instance using this profile
resource "aws_instance" "example" {
  count = var.create_example_instance ? 1 : 0

  ami                  = var.ami_id
  instance_type        = var.instance_type
  iam_instance_profile = aws_iam_instance_profile.this.name
  subnet_id            = var.subnet_id

  vpc_security_group_ids = var.security_group_ids
  metadata_options {
    http_tokens   = "required" # pragma: allowlist secret
    http_endpoint = "enabled"
  }
  user_data = base64encode(templatestring(local.user_data_template, {
    application_name = var.application_name != null ? var.application_name : "default-app"
    environment      = var.environment
  }))

  tags = merge(
    module.ec2_instance_role.role_tags,
    {
      Name = "${var.application_name != null ? var.application_name : "default"}-${var.environment}-instance"
    }
  )
}

# User data template as a local value
locals {
  user_data_template = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y amazon-cloudwatch-agent

    # Configure CloudWatch agent
    cat > /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json << 'EOL'
    {
      "agent": {
        "metrics_collection_interval": 60,
        "run_as_user": "cwagent"
      },
      "logs": {
        "logs_collected": {
          "files": {
            "collect_list": [
              {
                "file_path": "/var/log/messages",
                "log_group_name": "/aws/ec2/$${application_name}",
                "log_stream_name": "{instance_id}/messages"
              }
            ]
          }
        }
      },
      "metrics": {
        "namespace": "CWAgent/$${application_name}",
        "metrics_collected": {
          "cpu": {
            "measurement": [
              "cpu_usage_idle",
              "cpu_usage_iowait",
              "cpu_usage_user",
              "cpu_usage_system"
            ],
            "metrics_collection_interval": 60
          },
          "disk": {
            "measurement": [
              "used_percent"
            ],
            "metrics_collection_interval": 60,
            "resources": [
              "*"
            ]
          },
          "mem": {
            "measurement": [
              "mem_used_percent"
            ],
            "metrics_collection_interval": 60
          }
        }
      }
    }
    EOL

    # Start CloudWatch agent
    /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
      -a fetch-config \
      -m ec2 \
      -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json \
      -s

    # Install SSM agent (if not already installed)
    if ! systemctl is-active --quiet amazon-ssm-agent; then
      yum install -y amazon-ssm-agent
      systemctl enable amazon-ssm-agent
      systemctl start amazon-ssm-agent
    fi

    echo "Instance setup complete for $${application_name} in $${environment}"
  EOF
}
