terraform {
  required_version = ">= 1.10.4"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5"
    }
  }
}

data "aws_ami" "this" {
  count       = var.enabled ? 1 : 0
  most_recent = "true"
  dynamic "filter" {
    for_each = var.ami_filter
    content {
      name   = filter.key
      values = filter.value
    }
  }
  owners = var.ami_owners
}

resource "aws_iam_instance_profile" "this" {
  count       = var.enabled ? 1 : 0
  name_prefix = "${var.prefix}-bastion-host-instance-profile"
  role        = aws_iam_role.this[0].name
  tags        = var.tags
}

resource "aws_iam_role" "this" {
  count              = var.enabled ? 1 : 0
  name_prefix        = "${var.prefix}-bastion-host-iam-role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.this.json
  tags               = var.tags
}

resource "aws_iam_role_policy_attachment" "ssm" {
  count      = var.enabled ? 1 : 0
  role       = aws_iam_role.this[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "ec2_connect" {
  count      = var.enabled ? 1 : 0
  role       = aws_iam_role.this[0].name
  policy_arn = "arn:aws:iam::aws:policy/EC2InstanceConnect"
}

data "aws_iam_policy_document" "this" {
  statement {
    sid = "EC2ServiceMayAssumeRole"
    actions = [
      "sts:AssumeRole",
    ]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    effect = "Allow"
  }
}

resource "aws_security_group" "this" {
  name_prefix = "${var.prefix}-bastion-host-sg"
  description = "Bastion Host (SSM only) security group that should only allow egress"
  vpc_id      = var.vpc_id
}

resource "aws_vpc_security_group_egress_rule" "user_defined_ports_ipv4" {
  for_each          = { for idx, port in var.open_egress_ports : idx => port }
  security_group_id = aws_security_group.this.id
  description       = format("all IPv4 hosts on port %s", each.value)
  ip_protocol       = "tcp"
  from_port         = each.value
  to_port           = each.value
  cidr_ipv4         = "0.0.0.0/0"
  tags              = var.tags
}

resource "aws_vpc_security_group_egress_rule" "user_defined_ports_ipv6" {
  for_each          = { for idx, port in var.open_egress_ports : idx => port }
  security_group_id = aws_security_group.this.id
  description       = format("all IPv6 hosts on port %s", each.value)
  ip_protocol       = "tcp"
  from_port         = each.value
  to_port           = each.value
  cidr_ipv6         = "::/0"
  tags              = var.tags
}

resource "aws_vpc_security_group_egress_rule" "ssm" {
  security_group_id = aws_security_group.this.id
  description       = "all IPv4 hosts on port 443"
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_ipv4         = "0.0.0.0/0"
  tags              = var.tags
}

resource "aws_instance" "this" {
  count                       = var.enabled ? 1 : 0
  ami                         = data.aws_ami.this[0].id
  instance_type               = var.instance_type
  ebs_optimized               = true
  vpc_security_group_ids      = [aws_security_group.this.id]
  iam_instance_profile        = aws_iam_instance_profile.this[0].name
  associate_public_ip_address = false
  subnet_id                   = var.subnet
  monitoring                  = true
  root_block_device {
    delete_on_termination = true
    encrypted             = true
    tags                  = var.tags

  }
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }
  tags = merge(
    var.tags,
    { Name = var.instance_name }
  )
}
