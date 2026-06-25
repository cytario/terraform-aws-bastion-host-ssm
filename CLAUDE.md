# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A published Terraform module (`cytario/bastion-host-ssm/aws`) that provisions a single SSM-only EC2 bastion host: no SSH keys, no public IP, IMDSv2 enforced, encrypted EBS, IAM role for `AmazonSSMManagedInstanceCore` + `EC2InstanceConnect`, optional CloudWatch session logging. Flat root module — no submodules. Source files: `main.tf`, `variables.tf`, `outputs.tf`. Example consumer in `examples/secure-bastion/`.

## Commands

```bash
terraform init        # uses .terraform.lock.hcl, AWS provider >=5
terraform validate
terraform fmt -recursive
pre-commit run -a     # full gate: fmt, validate, terraform-docs, tflint, checkov
checkov -d .          # security scan (config in .checkov.yml)
```

No unit tests exist. Validation against AWS happens by applying `examples/secure-bastion` (uses default VPC + `alias/aws/ebs`). Terraform version pinned in `.terraform-version` (1.10.4); module requires `>= 1.10.4`.

## Conventions that bite

- **Conventional Commits are mandatory.** semantic-release (`.releaserc.json`) drives versioning + CHANGELOG from commit messages. `feat:` → minor, `fix:` → patch, `feat!:`/`BREAKING CHANGE` → major. Release workflow (`.github/workflows/release.yml`) fires only on push to `main` touching `**/*.tf` or the workflow file. Don't hand-edit `CHANGELOG.md` or version tags.
- **`terraform-docs` rewrites the Variables/Outputs tables in README.md** on pre-commit. Edit variable/output `description`s in the `.tf` files, not the README tables.
- **tflint enforces** documented variables/outputs, typed variables, naming conventions, pinned module sources — see the `--only` rules in `.pre-commit-config.yaml`.

## Architecture gotchas

- **`var.enabled` does NOT gate everything.** It gates the instance, IAM role/profile, AMI lookup, and log group (via `count`). But `aws_security_group.this` and all `aws_vpc_security_group_egress_rule.*` have no count — they are created even when `enabled = false`. Outputs use `join("", resource[*].x)` so they return `""` when disabled rather than erroring.
- **Egress rules fan out across three resources** in `main.tf`: `user_defined_ports_ipv4` (first CIDR only), `user_defined_ports_additional_cidrs` (`setproduct` of ports × remaining CIDRs), and `user_defined_ports_ipv6` (always `::/0`). Port 443 egress for SSM is always open. When changing egress logic, update all three together.
- **`kms_key_id` (default `null`)** falls back to AWS-managed keys for both the EBS root volume and the CloudWatch log group.
- AMI defaults to latest Amazon Linux 2023 arm64, hence the arm64 default instance type `t4g.nano`.
