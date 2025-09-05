# Contributing to terraform-aws-bastion-host-ssm

Thank you for your interest in contributing to this project! This document provides guidelines and instructions for contributing to the terraform-aws-bastion-host-ssm module.

## Table of Contents

- [Conventional Commits](#conventional-commits)
- [Development Setup](#development-setup)
- [Submitting Changes](#submitting-changes)
- [Code Standards](#code-standards)
- [Testing](#testing)
- [Agent/Automation Instructions](#agentautomation-instructions)

## Conventional Commits

**This project strictly requires the use of [Conventional Commits](https://www.conventionalcommits.org/) for all commit messages.**

### Why Conventional Commits?

This project uses automated semantic versioning and changelog generation through semantic-release. Conventional commits enable:

- **Automatic versioning**: Semantic versions are determined from commit types
- **Automated changelog**: Release notes are generated from commit messages
- **Clear change tracking**: Types make it easy to understand the nature of changes
- **Automated releases**: New versions are published automatically when changes are pushed to main

### Commit Message Format

All commit messages MUST follow this format:

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

### Commit Types

Use these standardized types:

- **feat**: A new feature for users (triggers minor version bump)
- **fix**: A bug fix for users (triggers patch version bump)
- **docs**: Documentation only changes
- **style**: Changes that do not affect code meaning (whitespace, formatting, etc.)
- **refactor**: Code changes that neither fix bugs nor add features
- **perf**: Performance improvements
- **test**: Adding missing tests or correcting existing tests
- **chore**: Changes to build process, auxiliary tools, libraries, etc.
- **ci**: Changes to CI configuration files and scripts
- **build**: Changes that affect the build system or external dependencies

### Breaking Changes

For breaking changes, add `!` after the type or add `BREAKING CHANGE:` in the footer:

```
feat!: remove deprecated variable support

BREAKING CHANGE: The deprecated `old_variable` has been removed. Use `new_variable` instead.
```

### Examples of Good Commit Messages

```bash
# New feature
feat: add support for custom KMS key encryption
feat(security): implement IMDSv2 enforcement

# Bug fix
fix: resolve duplicate security group rules issue
fix(outputs): correct CloudWatch log group ARN output

# Documentation
docs: update README with new variable descriptions
docs(examples): add advanced security configuration example

# Chores
chore: update pre-commit hooks to latest versions
chore(deps): bump terraform version to 1.6.0

# Breaking change
feat!: remove support for deprecated AMI variables

BREAKING CHANGE: Variables `legacy_ami_id` and `legacy_ami_name` have been removed. Use the new `ami_filter` variable instead.
```

### Examples of Bad Commit Messages

❌ **Avoid these patterns:**
```bash
# Too generic
"Update README"
"Fix bug"
"Add feature"

# Not conventional format
"Added new variable for KMS encryption"
"Fixed the issue with security groups"
"Documentation updates"

# Missing type
"support for custom AMI filters"
"resolve security group egress rule duplication"
```

## Development Setup

### Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) >= 1.0
- [pre-commit](https://pre-commit.com/) for code quality checks
- AWS CLI configured (for testing)

### Setting Up Pre-commit Hooks

This project uses pre-commit hooks to ensure code quality:

```bash
# Install pre-commit (if not already installed)
pip install pre-commit

# Install the hooks
pre-commit install

# Run hooks manually (optional)
pre-commit run --all-files
```

The pre-commit configuration includes:
- Terraform formatting (`terraform fmt`)
- Terraform validation (`terraform validate`)
- Terraform documentation generation (`terraform-docs`)
- Terraform linting (`tflint`)
- General file checks (trailing whitespace, merge conflicts, etc.)
- Security scanning with Checkov

## Submitting Changes

### Pull Request Process

1. **Fork the repository** and create a feature branch from `main`
2. **Make your changes** following the code standards
3. **Write conventional commit messages** for all commits
4. **Run pre-commit hooks** to ensure code quality
5. **Test your changes** (see Testing section)
6. **Submit a pull request** with a clear description

### Pull Request Requirements

- All commits must use conventional commit format
- Pre-commit hooks must pass
- Changes should be minimal and focused
- Include documentation updates for new features
- Add examples for new functionality

### Branch Naming

Use descriptive branch names that indicate the type of change:

```bash
feature/add-kms-encryption-support
fix/security-group-duplicate-rules
docs/update-variable-documentation
chore/update-dependencies
```

## Code Standards

### Terraform Code Style

- Use consistent indentation (2 spaces)
- Follow Terraform naming conventions
- Add descriptions to all variables and outputs
- Use validation blocks for input validation where appropriate
- Tag all resources consistently

### Documentation

- Update README.md for any variable or output changes
- Include usage examples for new features
- Add comments for complex logic
- Ensure terraform-docs generates correctly

### Security

- Follow AWS security best practices
- Use least privilege principles
- Enable encryption by default where possible
- Validate all user inputs
- Run security scans (Checkov) before submitting

## Testing

### Validation Steps

Before submitting changes, ensure:

1. **Terraform validation passes**:
   ```bash
   terraform init
   terraform validate
   ```

2. **Formatting is correct**:
   ```bash
   terraform fmt -check -recursive
   ```

3. **Pre-commit hooks pass**:
   ```bash
   pre-commit run --all-files
   ```

4. **Documentation is up to date**:
   ```bash
   terraform-docs markdown table --output-file README.md .
   ```

### Manual Testing

For significant changes, test the module:

1. Create a test configuration in the `examples/` directory
2. Run `terraform plan` to validate the configuration
3. If possible, apply the configuration in a test environment
4. Verify the functionality works as expected

## Agent/Automation Instructions

### For Automated Tools and AI Agents

When contributing via automated tools, agents, or bots, please ensure:

1. **MANDATORY**: All commits MUST use conventional commit format
2. **Use appropriate commit types**:
   - `feat:` for new functionality
   - `fix:` for bug fixes
   - `docs:` for documentation-only changes
   - `refactor:` for code improvements without functional changes
   - `chore:` for maintenance tasks

3. **Include descriptive commit messages**:
   ```bash
   # Good examples for agents
   feat: implement automatic AMI selection based on architecture
   fix: correct variable validation for port ranges
   docs: generate updated terraform-docs output
   refactor: optimize security group resource creation
   ```

4. **Validate before committing**:
   - Run `terraform fmt` to format code
   - Run `terraform validate` to check syntax
   - Ensure all required variables have descriptions
   - Update documentation if variables or outputs change

5. **Follow semantic versioning implications**:
   - Use `feat:` for backwards-compatible new features
   - Use `fix:` for backwards-compatible bug fixes
   - Use `feat!:` or add `BREAKING CHANGE:` footer for breaking changes

6. **Batch related changes**: Group related changes into single commits rather than many small commits

### Automated PR Requirements

Automated pull requests should:
- Include clear descriptions of what was changed and why
- Reference any related issues with `Fixes #123` or `Closes #456`
- Use conventional commit messages for all commits
- Pass all pre-commit hooks and validation checks

## Questions and Support

If you have questions about contributing:

1. Check existing [Issues](https://github.com/cytario/terraform-aws-bastion-host-ssm/issues)
2. Review the [README.md](README.md) for usage examples
3. Create a new issue for questions or bug reports

Thank you for contributing to make this module better! 🚀