output "instance_id" {
  value       = join("", aws_instance.this[*].id)
  description = "Bastion host instance ID"
}

output "instance_arn" {
  value       = join("", aws_instance.this[*].arn)
  description = "Bastion host instance ARN"
}

output "security_group_id" {
  value       = aws_security_group.this.id
  description = "ID of bastion host's security group"
}

output "security_group_arn" {
  value       = aws_security_group.this.arn
  description = "ARN of bastion host's security group"
}

output "iam_role_arn" {
  value       = join("", aws_iam_role.this[*].arn)
  description = "ARN of the bastion host IAM role"
}

output "instance_profile_arn" {
  value       = join("", aws_iam_instance_profile.this[*].arn)
  description = "ARN of the bastion host instance profile"
}

output "cloudwatch_log_group_name" {
  value       = join("", aws_cloudwatch_log_group.ssm_session_logs[*].name)
  description = "CloudWatch log group name for SSM session logs"
}

output "cloudwatch_log_group_arn" {
  value       = join("", aws_cloudwatch_log_group.ssm_session_logs[*].arn)
  description = "CloudWatch log group ARN for SSM session logs"
}
