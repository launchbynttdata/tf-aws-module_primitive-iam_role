# EKS Service Account (IRSA) Role Example

This example demonstrates creating an IAM role for Kubernetes service accounts using IAM Roles for Service Accounts (IRSA).

## Features Demonstrated

- **Web Identity Federation**: OIDC provider trust relationship
- **Service account mapping**: Kubernetes namespace and service account binding
- **AWS Load Balancer Controller**: Complete policy for ALB/NLB management
- **Cluster Autoscaler**: Auto Scaling Group permissions
- **Custom policies**: Additional application-specific permissions

## Security Features

1. **OIDC audience verification**: Ensures tokens are for STS
2. **Subject validation**: Matches specific service account
3. **Namespace isolation**: Scoped to specific Kubernetes namespace
4. **Condition-based access**: Multiple verification layers

## Usage

```bash
# Basic service account role
terraform apply \
  -var="cluster_name=my-eks-cluster" \
  -var="service_account_name=my-service-account" \
  -var="oidc_provider_url=oidc.eks.us-west-2.amazonaws.com/id/EXAMPLED539D4633E53DE1B716D3041E"

# With Load Balancer Controller permissions
terraform apply \
  -var="cluster_name=my-eks-cluster" \
  -var="service_account_name=aws-load-balancer-controller" \
  -var="namespace=kube-system" \
  -var="enable_load_balancer_controller=true"

# With Cluster Autoscaler permissions
terraform apply \
  -var="enable_cluster_autoscaler=true" \
  -var="custom_policy_statements=[{
    Effect   = \"Allow\"
    Action   = [\"ec2:DescribeInstances\"]
    Resource = \"*\"
  }]"
```

## Kubernetes Integration

After applying, annotate your service account:

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: my-service-account
  namespace: default
  annotations:
    eks.amazonaws.com/role-arn: arn:aws:iam::ACCOUNT:role/my-eks-cluster-my-service-account-role
```

## Testing

This example tests:

- OIDC web identity federation
- Complex condition blocks
- Multiple policy attachments
- Service account annotation generation
- EKS-specific trust relationships

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.100.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_eks_service_account_role"></a> [eks\_service\_account\_role](#module\_eks\_service\_account\_role) | ../../ | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.aws_load_balancer_controller](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.cluster_autoscaler](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role_policy.custom_permissions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.aws_load_balancer_controller](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.cluster_autoscaler](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the EKS cluster | `string` | n/a | yes |
| <a name="input_service_account_name"></a> [service\_account\_name](#input\_service\_account\_name) | Name of the Kubernetes service account | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Kubernetes namespace for the service account | `string` | `"default"` | no |
| <a name="input_oidc_provider_url"></a> [oidc\_provider\_url](#input\_oidc\_provider\_url) | OIDC provider URL for the EKS cluster (without https://) | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name (e.g., dev, staging, prod) | `string` | `"dev"` | no |
| <a name="input_enable_load_balancer_controller"></a> [enable\_load\_balancer\_controller](#input\_enable\_load\_balancer\_controller) | Whether to enable AWS Load Balancer Controller permissions | `bool` | `false` | no |
| <a name="input_enable_cluster_autoscaler"></a> [enable\_cluster\_autoscaler](#input\_enable\_cluster\_autoscaler) | Whether to enable Cluster Autoscaler permissions | `bool` | `false` | no |
| <a name="input_custom_policy_statements"></a> [custom\_policy\_statements](#input\_custom\_policy\_statements) | Additional IAM policy statements to attach to the role | <pre>list(object({<br/>    Effect    = string<br/>    Action    = list(string)<br/>    Resource  = any<br/>    Condition = optional(map(any))<br/>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_eks_service_account_role_arn"></a> [eks\_service\_account\_role\_arn](#output\_eks\_service\_account\_role\_arn) | The ARN of the EKS service account role |
| <a name="output_eks_service_account_role_name"></a> [eks\_service\_account\_role\_name](#output\_eks\_service\_account\_role\_name) | The name of the EKS service account role |
| <a name="output_kubernetes_service_account_annotation"></a> [kubernetes\_service\_account\_annotation](#output\_kubernetes\_service\_account\_annotation) | Annotation to add to the Kubernetes service account |
| <a name="output_kubernetes_service_account_yaml"></a> [kubernetes\_service\_account\_yaml](#output\_kubernetes\_service\_account\_yaml) | YAML manifest for the Kubernetes service account |
| <a name="output_role_arn"></a> [role\_arn](#output\_role\_arn) | The ARN of the IAM role |
| <a name="output_role_name"></a> [role\_name](#output\_role\_name) | The name of the IAM role |
| <a name="output_role_id"></a> [role\_id](#output\_role\_id) | The unique ID of the IAM role |
| <a name="output_role_tags"></a> [role\_tags](#output\_role\_tags) | The tags assigned to the IAM role |
<!-- END_TF_DOCS -->
