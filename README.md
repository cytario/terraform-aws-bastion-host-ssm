# terraform-aws-bastion-host-ssm

Terraform module to create a simple and secure bastion host with SSM-only access and enhanced security features.

## Security Features

- **SSM-only access**: No SSH keys or public IPs required
- **Encrypted EBS volumes**: Support for custom KMS keys
- **IMDSv2 enforced**: Enhanced instance metadata security
- **Termination protection**: Optional protection against accidental termination
- **Session logging**: CloudWatch integration for audit trails
- **Restrictive egress**: Configurable CIDR blocks instead of 0.0.0.0/0
- **Security tagging**: Automatic security-focused resource tagging
- **Enhanced monitoring**: Detailed CloudWatch metrics enabled

## Security Best Practices

- Use VPC endpoints for SSM to avoid internet traffic
- Regularly rotate AMIs to ensure security patches
- Monitor CloudWatch logs for session activity
- Use custom KMS keys for encryption key management
- Apply least privilege access to the bastion host

## Usage

```hcl
module "bastion" {
  source = "cytario/bastion-host-ssm/aws"
  
  prefix                      = "prod"
  vpc_id                     = "vpc-xxxxxxxxx"
  subnet                     = "subnet-xxxxxxxxx"
  
  # Security enhancements
  kms_key_id                 = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
  enable_termination_protection = true
  enable_ssm_session_logging = true
  egress_cidr_blocks        = ["10.0.0.0/8", "172.16.0.0/16"]
  
  # Standard configuration
  instance_type             = "t4g.nano"
  open_egress_ports        = [5432, 3306]
  
  tags = {
    Environment = "production"
    Project     = "infrastructure"
    Security    = "high"
  }
}
```

## Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| enable_termination_protection | Enable EC2 instance termination protection | `bool` | `false` | no |
| kms_key_id | KMS key ID for EBS encryption | `string` | `null` | no |
| enable_ssm_session_logging | Enable CloudWatch logging for SSM sessions | `bool` | `true` | no |
| egress_cidr_blocks | List of CIDR blocks for egress rules | `list(string)` | `["0.0.0.0/0"]` | no |

## Outputs

| Name | Description |
|------|-------------|
| security_group_arn | ARN of bastion host's security group |
| iam_role_arn | ARN of the bastion host IAM role |
| cloudwatch_log_group_name | CloudWatch log group name for SSM session logs | 
