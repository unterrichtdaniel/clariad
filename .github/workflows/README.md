# GitHub Actions CI Guide

This guide provides a quick reference for Clariad's GitHub Actions CI workflows.

## CI Workflows

Clariad uses two main GitHub Actions workflows:

### 1. Code Quality and Tests (`code-tests.yml`)

**Triggered by**:
- Pushes to main/master/develop branches (code files only)
- Pull requests to these branches (code files only)

**Ignores changes to**:
- Docker configuration
- Infrastructure files
- Documentation

**Jobs**:
- `lint`: Code quality checks
- `unit-test`: Unit tests
- `integration-test`: Integration tests with databases

### 2. Infrastructure Tests (`infra-tests.yml`)

**Triggered by**:
- Changes to Docker configuration
- Changes to environment templates
- Changes to setup scripts
- Weekly scheduled runs

**Jobs**:
- `validate-config`: Validates configuration files
- `docker-test`: Tests Docker environment
- `setup-script-test`: Tests setup scripts

## Common CI Issues and Solutions

### Code Quality Issues

| Issue | Solution |
| ----- | -------- |
| Black formatting failures | Run `poetry run black .` locally |
| isort import order issues | Run `poetry run isort .` locally |
| flake8 linting errors | Fix specific issues reported in logs |
| mypy type errors | Add proper type annotations |

### Test Failures

| Issue | Solution |
| ----- | -------- |
| Unit test failures | Check test output and fix code issues |
| Integration test failures | Verify database setup and connections |
| Docker test failures | Check Docker Compose configuration |
| Script validation failures | Verify script syntax and required components |

### Environment Issues

| Issue | Solution |
| ----- | -------- |
| Missing environment variables | Update `.env.template` with required variables |
| Docker service failures | Check logs in the artifacts section |
| Database initialization issues | Verify SQL scripts and initialization code |

## Testing Locally Before Pushing

Run the test script to verify your changes will pass CI:

```bash
./scripts/test_ci.sh
```

This script runs all the same checks as the GitHub Actions workflows.

## Adding a New CI Workflow

1. Create a new YAML file in `.github/workflows/`
2. Define triggers and jobs
3. Test locally before pushing
4. Update the CI/CD documentation

## CI Status Badge

Add this badge to README.md to show CI status:

```markdown
[![Code Tests](https://github.com/yourusername/clariad/actions/workflows/code-tests.yml/badge.svg)](https://github.com/yourusername/clariad/actions/workflows/code-tests.yml)
[![Infrastructure Tests](https://github.com/yourusername/clariad/actions/workflows/infra-tests.yml/badge.svg)](https://github.com/yourusername/clariad/actions/workflows/infra-tests.yml)
```

## Workflow Visualization

![Workflow Diagram](../docs/ci_cd/workflow-diagram.png)
