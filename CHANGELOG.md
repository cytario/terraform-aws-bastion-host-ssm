# Changelog

All notable changes to this project will be documented in this file.

## [1.3.0](https://github.com/cytario/terraform-aws-bastion-host-ssm/compare/v1.2.1...v1.3.0) (2025-08-13)


### Features

* add security_group_id to outputs ([6aaee24](https://github.com/cytario/terraform-aws-bastion-host-ssm/commit/6aaee241ec8fd76df24f6bfea776a4a036325f8d))

## [1.2.1](https://github.com/cytario/terraform-aws-bastion-host-ssm/compare/v1.2.0...v1.2.1) (2025-08-11)


### Bug Fixes

* give bastion host EC2 instance a name tag ([971ce63](https://github.com/cytario/terraform-aws-bastion-host-ssm/commit/971ce63f0b135936849a06c0097451fbdb24d8c0))

## [1.2.0](https://github.com/cytario/terraform-aws-bastion-host-ssm/compare/v1.1.2...v1.2.0) (2025-06-24)


### Features

* add vpc_id input and deploy security group in vpc ([e9f62a9](https://github.com/cytario/terraform-aws-bastion-host-ssm/commit/e9f62a9498cb6ac042f1d817e49d5c33dad43911))

## [1.1.2](https://github.com/cytario/terraform-aws-bastion-host-ssm/compare/v1.1.1...v1.1.2) (2025-06-24)


### Bug Fixes

* switch to AL2023 and ARM AMI ([f30e175](https://github.com/cytario/terraform-aws-bastion-host-ssm/commit/f30e175141200beabfa0e23ce550c75ac6b99406))

## [1.1.1](https://github.com/cytario/terraform-aws-bastion-host-ssm/compare/v1.1.0...v1.1.1) (2025-06-24)


### Bug Fixes

* use for_each correctly for list(number) ([9e175c8](https://github.com/cytario/terraform-aws-bastion-host-ssm/commit/9e175c852caa4f232df1570e52be547f07b5d87f))

## [1.1.0](https://github.com/cytario/terraform-aws-bastion-host-ssm/compare/v1.0.0...v1.1.0) (2025-06-24)


### Features

* provide instance's id and arn as outputs ([3a330cf](https://github.com/cytario/terraform-aws-bastion-host-ssm/commit/3a330cfcaf65c8cc3ac075f012a9a515c22891a2))

## 1.0.0 (2025-06-24)


### Features

* basic bastion host ([668f49a](https://github.com/cytario/terraform-aws-bastion-host-ssm/commit/668f49a862f78c39d82a89d214c8bb2033b8c515))
