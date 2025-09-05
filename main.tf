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

resource "aws_iam_role_policy" "ssm_session_logging" {
  count       = var.enabled && var.enable_ssm_session_logging ? 1 : 0
  name_prefix = "${var.prefix}-bastion-ssm-logging-iam-policy"
  role        = aws_iam_role.this[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams"
        ]
        Resource = var.enable_ssm_session_logging ? "${aws_cloudwatch_log_group.ssm_session_logs[0].arn}:*" : "*"
      }
    ]
  })
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
  description = "Bastion Host security group - SSM-only access with controlled egress"
  vpc_id      = var.vpc_id
  tags = merge(
    var.tags,
    {
      Name       = "${var.prefix}-bastion-host-sg"
      Purpose    = "bastion-host-security"
      AccessType = "ssm-only"
    }
  )
}

resource "aws_vpc_security_group_egress_rule" "user_defined_ports_ipv4" {
  for_each          = { for idx, port in var.open_egress_ports : idx => port }
  security_group_id = aws_security_group.this.id
  description       = format("Controlled access to port %s", each.value)
  ip_protocol       = "tcp"
  from_port         = each.value
  to_port           = each.value
  cidr_ipv4         = var.egress_cidr_blocks[0] # Use first CIDR block for backward compatibility
  tags              = var.tags
}

resource "aws_vpc_security_group_egress_rule" "user_defined_ports_additional_cidrs" {
  for_each = {
    for combo in setproduct(range(length(var.open_egress_ports)), slice(var.egress_cidr_blocks, 1, length(var.egress_cidr_blocks))) :
    "${combo[0]}-${combo[1]}" => {
      port = var.open_egress_ports[combo[0]]
      cidr = combo[1]
    }
  }
  security_group_id = aws_security_group.this.id
  description       = format("Controlled access to port %s for %s", each.value.port, each.value.cidr)
  ip_protocol       = "tcp"
  from_port         = each.value.port
  to_port           = each.value.port
  cidr_ipv4         = each.value.cidr
  tags              = var.tags
}

resource "aws_vpc_security_group_egress_rule" "user_defined_ports_ipv6" {
  for_each          = { for idx, port in var.open_egress_ports : idx => port }
  security_group_id = aws_security_group.this.id
  description       = format("IPv6 access to port %s", each.value)
  ip_protocol       = "tcp"
  from_port         = each.value
  to_port           = each.value
  cidr_ipv6         = "::/0"
  tags              = var.tags
}

resource "aws_vpc_security_group_egress_rule" "ssm" {
  security_group_id = aws_security_group.this.id
  description       = "HTTPS egress for SSM communication"
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_ipv4         = "0.0.0.0/0"
  tags              = var.tags
}

resource "aws_cloudwatch_log_group" "ssm_session_logs" {
  count             = var.enabled && var.enable_ssm_session_logging ? 1 : 0
  name              = "/aws/ssm/${var.prefix}-bastion-host-sessions"
  retention_in_days = var.ssm_session_logs_retention
  kms_key_id        = var.kms_key_id
  tags = merge(
    var.tags,
    {
      Name    = "${var.prefix}-bastion-ssm-logs"
      Purpose = "security-audit"
      LogType = "ssm-sessions"
    }
  )
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
  disable_api_termination     = var.enable_termination_protection
  root_block_device {
    delete_on_termination = true
    encrypted             = true
    kms_key_id            = var.kms_key_id
    tags = merge(
      var.tags,
      {
        Name      = "${var.prefix}-bastion-root-volume"
        Purpose   = "bastion-host"
        Encrypted = "true"
      }
    )
  }
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }
  tags = merge(
    var.tags,
    {
      Name          = var.instance_name
      Purpose       = "bastion-host"
      AccessMethod  = "ssm-only"
      SecurityLevel = "high"
    }
  )
}
