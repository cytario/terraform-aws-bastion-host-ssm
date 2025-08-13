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
  description = "ID of bastion host's security group "
}
