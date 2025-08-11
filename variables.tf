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
