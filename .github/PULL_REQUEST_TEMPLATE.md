## Description

Brief description of the changes in this PR.

## Type of Change

Please select the type of change this PR introduces:

- [ ] **feat**: New feature (non-breaking change which adds functionality)
- [ ] **fix**: Bug fix (non-breaking change which fixes an issue)
- [ ] **docs**: Documentation only changes
- [ ] **style**: Changes that do not affect code meaning (whitespace, formatting, etc.)
- [ ] **refactor**: Code change that neither fixes a bug nor adds a feature
- [ ] **perf**: Performance improvement
- [ ] **test**: Adding missing tests or correcting existing tests
- [ ] **chore**: Changes to build process, auxiliary tools, or maintenance
- [ ] **ci**: Changes to CI configuration files and scripts
- [ ] **BREAKING CHANGE**: Change that would cause existing functionality to not work as expected

## Conventional Commits Checklist

**⚠️ IMPORTANT**: This project requires [Conventional Commits](https://www.conventionalcommits.org/) for automated versioning.

- [ ] All commit messages follow the conventional commits format: `<type>[optional scope]: <description>`
- [ ] Commit types are appropriate (feat, fix, docs, style, refactor, perf, test, chore, ci)
- [ ] Breaking changes are marked with `!` or include `BREAKING CHANGE:` in footer
- [ ] Commit messages are descriptive and explain the "what" and "why"

### Examples of Good Commit Messages:
```
feat: add support for custom KMS key encryption
fix: resolve duplicate security group rules issue
docs: update README with new variable descriptions
chore: update pre-commit hooks to latest versions
feat!: remove deprecated variable support
```

## Testing

- [ ] I have run `terraform fmt` to format the code
- [ ] I have run `terraform validate` to check syntax
- [ ] Pre-commit hooks pass (`pre-commit run --all-files`)
- [ ] Documentation has been updated if needed
- [ ] I have tested these changes locally (if applicable)

## Related Issues

Closes #(issue_number)

## Additional Notes

Any additional information, context, or screenshots that would be helpful for reviewers.