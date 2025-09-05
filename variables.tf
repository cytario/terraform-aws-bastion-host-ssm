variable "prefix" {
  description = "used as a prefix for resource names"
  type        = string
  default     = "prod"
}

variable "enabled" {
  description = "Whether to provision the bastion host"
  type        = bool
  default     = true
}

variable "subnet" {
  type        = string
  description = "AWS subnet ID to deploy instance to (needs to be in vpc provided as vpc_id)"
}

variable "vpc_id" {
  type        = string
  description = "AWS VPC ID to create security group in"
}

variable "instance_type" {
  type        = string
  default     = "t4g.nano"
  description = "Bastion instance type"
}

variable "instance_name" {
  type        = string
  default     = "Bastion Host"
  description = "Name of the EC2 instance"
}

variable "open_egress_ports" {
  type        = list(number)
  default     = [5432] # postgresql
  description = "Ports to open for egress"
  validation {
    condition     = alltrue([for port in var.open_egress_ports : port >= 1 && port <= 65535])
    error_message = "All ports must be valid port numbers between 1 and 65535."
  }
}

variable "ami_filter" {
  description = "Map of filters to find AMI to use"
  type        = map(list(string))
  default = {
    name = ["al2023-ami-2023*-arm64"]
  }
}

variable "ami_owners" {
  description = "List of owners used to select the AMI"
  type        = list(string)
  default     = ["amazon"]
}

variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resources"
  default     = {}
}

variable "kms_key_id" {
  type        = string
  description = "KMS key ID for EBS encryption. If not provided, uses the default AWS managed key"
  default     = null
}

variable "enable_termination_protection" {
  type        = bool
  description = "Enable EC2 instance termination protection"
  default     = false
}

variable "egress_cidr_blocks" {
  type        = list(string)
  description = "List of CIDR blocks for egress rules. Defaults to 0.0.0.0/0 for backward compatibility"
  default     = ["0.0.0.0/0"]
  validation {
    condition     = alltrue([for cidr in var.egress_cidr_blocks : can(cidrhost(cidr, 0))])
    error_message = "All values must be valid CIDR blocks."
  }
}

variable "enable_ssm_session_logging" {
  type        = bool
  description = "Enable CloudWatch logging for SSM sessions"
  default     = true
}

variable "ssm_session_logs_retention" {
  type        = number
  description = "Days to retain CloudWatch logs for SSM sessions"
  default     = 365
}
