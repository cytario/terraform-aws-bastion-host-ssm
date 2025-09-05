output "bastion_instance_id" {
  description = "ID of the bastion host instance"
  value       = module.secure_bastion.instance_id
}

output "bastion_security_group_arn" {
  description = "ARN of the bastion host security group"
  value       = module.secure_bastion.security_group_arn
}

output "bastion_iam_role_arn" {
  description = "ARN of the bastion host IAM role"
  value       = module.secure_bastion.iam_role_arn
}

output "bastion_log_group" {
  description = "CloudWatch log group for bastion host sessions"
  value       = module.secure_bastion.cloudwatch_log_group_name
}
