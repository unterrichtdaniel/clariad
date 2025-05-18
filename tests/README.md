# Clariad Tests

This directory contains tests for the Clariad project, organized into three main categories:

## Test Categories

### 1. [Unit Tests](unit/)

- Focus on testing individual components in isolation
- Do not require external services
- Fast to execute
- Test a single unit of code (function, class, module)

### 2. [Integration Tests](integration/)

- Test interaction between components
- Require external services (databases, Redis, etc.)
- Verify correct behavior of the system as a whole
- Need proper setup and teardown of test environment

### 3. [Infrastructure Tests](infrastructure/)

- Test configuration files and setup scripts
- Verify development environment configuration
- Check Docker and container setup
- Validate deployment infrastructure

## Running Tests

Each category of tests can be run independently:

```bash
# Run unit tests only
poetry run pytest tests/unit

# Run integration tests only
poetry run pytest tests/integration

# Run infrastructure tests only
poetry run pytest tests/infrastructure

# Run all tests
poetry run pytest
```

## CI/CD Integration

These tests are integrated with the CI/CD pipeline through GitHub Actions:

- Unit and integration tests are run by the `code-tests.yml` workflow
- Infrastructure tests are run by the `infra-tests.yml` workflow

See the [CI/CD documentation](../docs/ci_cd/README.md) for more details.

## Test Fixtures and Utilities

Common fixtures and test utilities should be placed in the `conftest.py` file at the root of the tests directory or in the respective test category directories.

## Adding New Tests

When adding new tests:

1. Identify the appropriate category for your test
2. Create a new file with a `test_` prefix in the corresponding directory
3. Write test functions with a `test_` prefix
4. Use appropriate pytest fixtures and markers
5. Run the tests locally before pushing

## Test Coverage

We aim for high test coverage, especially for critical components. Run tests with coverage reporting:

```bash
poetry run pytest --cov=clariad
```

View the HTML coverage report:

```bash
poetry run pytest --cov=clariad --cov-report=html
# Open htmlcov/index.html in your browser
```
