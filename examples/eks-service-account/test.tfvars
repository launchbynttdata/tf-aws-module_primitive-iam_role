# EKS Service Account Role Test Configuration
cluster_name         = "test-eks-cluster"
service_account_name = "test-service-account"
namespace            = "test-namespace"
oidc_provider_url    = "oidc.eks.us-east-1.amazonaws.com/id/ABCDEF0123456789ABCDEF0123456789"
environment          = "test"

# Enable AWS Load Balancer Controller permissions for testing
enable_load_balancer_controller = true

# Enable Cluster Autoscaler permissions for testing
enable_cluster_autoscaler = true

# Additional custom policy statements for testing
custom_policy_statements = [
  {
    Effect = "Allow"
    Action = [
      "s3:GetObject",
      "s3:ListBucket"
    ]
    Resource = [
      "arn:aws:s3:::test-eks-bucket",
      "arn:aws:s3:::test-eks-bucket/*"
    ]
  },
  {
    Effect = "Allow"
    Action = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret"
    ]
    Resource = [
      "arn:aws:secretsmanager:us-east-1:*:secret:test-eks-secret-*"
    ]
  }
]
