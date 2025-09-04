# Secure Bastion Host Example

This example demonstrates how to deploy the bastion host module with enhanced security features enabled.

## Security Features Demonstrated

- **Custom KMS encryption**: Uses AWS managed EBS key for encryption
- **Termination protection**: Prevents accidental instance termination
- **Session logging**: Enables CloudWatch logging for audit trails
- **Restricted egress**: Limits outbound traffic to private network ranges only
- **Enhanced tagging**: Includes security and compliance tags

## Usage

1. Configure your AWS provider:
```hcl
provider "aws" {
  region = "us-east-1"
}
```

2. Deploy the infrastructure:
```bash
terraform init
terraform plan
terraform apply
```

3. Connect to the bastion host:
```bash
aws ssm start-session --target <instance-id>
```

4. Monitor session logs:
```bash
aws logs tail /aws/ssm/secure-example-bastion-host-sessions --follow
```

## Security Benefits

- No SSH keys required or stored
- No public IP exposure
- All sessions logged to CloudWatch
- Encrypted storage with managed keys
- Network access limited to private ranges
- Termination protection enabled