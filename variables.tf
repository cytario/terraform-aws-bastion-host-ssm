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
  description = "AWS subnet ID to deploy instance to"
}

variable "instance_type" {
  type        = string
  default     = "t4g.nano"
  description = "Bastion instance type"
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
    name = ["amzn2-ami-hvm-2.*-x86_64-ebs"]
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
