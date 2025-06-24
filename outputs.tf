output "instance_id" {
  value       = join("", aws_instance.this[*].id)
  description = "Bastion host instance ID"
}

output "instance_arn" {
  value       = join("", aws_instance.this[*].arn)
  description = "Bastion host instance ARN"
}
