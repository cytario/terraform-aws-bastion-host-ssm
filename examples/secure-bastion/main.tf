# Example: Secure bastion host with enhanced security features

data "aws_vpc" "existing" {
  default = true
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.existing.id]
  }
}

data "aws_kms_key" "ebs" {
  key_id = "alias/aws/ebs"
}

module "secure_bastion" {
  source = "../.."

  prefix                        = "secure-example"
  vpc_id                       = data.aws_vpc.existing.id
  subnet                       = data.aws_subnets.private.ids[0]
  
  # Security enhancements
  kms_key_id                   = data.aws_kms_key.ebs.arn
  enable_termination_protection = true
  enable_ssm_session_logging   = true
  egress_cidr_blocks          = [
    "10.0.0.0/8",     # RFC 1918 - Private networks
    "172.16.0.0/12",  # RFC 1918 - Private networks  
    "192.168.0.0/16"  # RFC 1918 - Private networks
  ]
  
  # Application-specific ports
  open_egress_ports = [5432, 3306, 1433] # PostgreSQL, MySQL, SQL Server
  
  instance_type = "t4g.micro"
  instance_name = "Secure Bastion Example"
  
  tags = {
    Environment   = "example"
    Purpose       = "secure-bastion-demo"
    Security      = "enhanced"
    Compliance    = "required"
  }
}
