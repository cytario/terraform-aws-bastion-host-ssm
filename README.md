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
- Restrict egress traffic to only required CIDR blocks
- Enable termination protection for production environments
- Use ARM-based instances (t4g.nano) for better cost efficiency

## Connecting to Resources

Once deployed, connect to your bastion host using AWS Session Manager:

```bash
# Connect to the bastion host
aws ssm start-session --target i-1234567890abcdef0

# Connect to a database through the bastion (example with PostgreSQL)
# First, start a session with port forwarding
aws ssm start-session \
  --target i-1234567890abcdef0 \
  --document-name AWS-StartPortForwardingSession \
  --parameters '{"portNumber":["5432"],"localPortNumber":["5432"]}'

# Then connect to your database from another terminal
psql -h localhost -p 5432 -U myuser mydb
```

## Module Structure

This module creates the following AWS resources:

- **EC2 Instance**: The bastion host with SSM agent
- **Security Group**: Controls ingress/egress traffic
- **IAM Role & Instance Profile**: Provides SSM permissions
- **CloudWatch Log Group**: Stores SSM session logs (optional)
- **EBS Encryption**: Uses KMS for volume encryption (optional)

## Usage

### Basic Example

```hcl
module "bastion" {
  source = "cytario/bastion-host-ssm/aws"

  prefix = "prod"
  vpc_id = "vpc-xxxxxxxxx"
  subnet = "subnet-xxxxxxxxx"
  
  tags = {
    Environment = "production"
    Project     = "infrastructure"
  }
}
```

### Advanced Example with Enhanced Security

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
  ssm_session_logs_retention = 90
  egress_cidr_blocks        = ["10.0.0.0/8", "172.16.0.0/16"]
  
  # Instance configuration
  instance_type             = "t4g.nano"
  instance_name            = "Production Bastion Host"
  open_egress_ports        = [5432, 3306, 6379]
  
  # Custom AMI selection
  ami_filter = {
    name = ["al2023-ami-2023*-arm64"]
  }
  ami_owners = ["amazon"]
  
  tags = {
    Environment = "production"
    Project     = "infrastructure"
    Security    = "high"
    Compliance  = "required"
  }
}
```

## Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| prefix | Used as a prefix for resource names | `string` | `"prod"` | no |
| enabled | Whether to provision the bastion host | `bool` | `true` | no |
| subnet | AWS subnet ID to deploy instance to (needs to be in vpc provided as vpc_id) | `string` | n/a | yes |
| vpc_id | AWS VPC ID to create security group in | `string` | n/a | yes |
| instance_type | Bastion instance type | `string` | `"t4g.nano"` | no |
| instance_name | Name of the EC2 instance | `string` | `"Bastion Host"` | no |
| open_egress_ports | Ports to open for egress | `list(number)` | `[5432]` | no |
| ami_filter | Map of filters to find AMI to use | `map(list(string))` | `{name = ["al2023-ami-2023*-arm64"]}` | no |
| ami_owners | List of owners used to select the AMI | `list(string)` | `["amazon"]` | no |
| tags | A mapping of tags to assign to the resources | `map(string)` | `{}` | no |
| kms_key_id | KMS key ID for EBS encryption. If not provided, uses the default AWS managed key | `string` | `null` | no |
| enable_termination_protection | Enable EC2 instance termination protection | `bool` | `false` | no |
| egress_cidr_blocks | List of CIDR blocks for egress rules. Defaults to 0.0.0.0/0 for backward compatibility | `list(string)` | `["0.0.0.0/0"]` | no |
| enable_ssm_session_logging | Enable CloudWatch logging for SSM sessions | `bool` | `true` | no |
| ssm_session_logs_retention | Days to retain CloudWatch logs for SSM sessions | `number` | `365` | no |

## Outputs

| Name | Description |
|------|-------------|
| instance_id | Bastion host instance ID |
| instance_arn | Bastion host instance ARN |
| security_group_id | ID of bastion host's security group |
| security_group_arn | ARN of bastion host's security group |
| iam_role_arn | ARN of the bastion host IAM role |
| instance_profile_arn | ARN of the bastion host instance profile |
| cloudwatch_log_group_name | CloudWatch log group name for SSM session logs |
| cloudwatch_log_group_arn | CloudWatch log group ARN for SSM session logs |

## Contributing

We welcome contributions to improve this Terraform module! Please read our [Contributing Guidelines](CONTRIBUTING.md) for detailed information about:

- **Conventional Commits**: This project uses conventional commits for automated versioning and changelog generation
- **Development workflow**: How to set up your development environment and submit changes
- **Code standards**: Formatting, validation, and security requirements
- **Testing**: How to validate your changes before submitting

For quick reference, all commit messages must follow the [Conventional Commits](https://www.conventionalcommits.org/) specification:

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

Examples:
- `feat: add support for custom AMI filters`
- `fix: resolve security group egress rule duplication`
- `docs: update README with new variable descriptions`
- `chore: update dependencies to latest versions`

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details. 
