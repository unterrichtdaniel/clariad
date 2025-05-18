# CI/CD Pipeline Documentation

This document outlines the Continuous Integration and Continuous Deployment (CI/CD) setup for the Clariad project.

## Current Implementation

The CI/CD pipeline is implemented with GitHub Actions and separated into two distinct workflows to ensure clear responsibility:

### 1. Code Quality and Tests (`code-tests.yml`)

This workflow focuses on the codebase itself and runs on code changes:

- **Triggers**:
  - Pushes to main/master/develop branches
  - Pull requests to these branches
  - Ignores changes to infrastructure files and documentation

- **Jobs**:
  1. **Code Quality Checks**
     - Linting with flake8
     - Code formatting checks with black
     - Import sorting with isort
     - Type checking with mypy

  2. **Unit Tests**
     - Runs unit tests without external dependencies
     - Validates core functionality in isolation

  3. **Integration Tests**
     - Uses containerized services:
       - PostgreSQL for primary database
       - PostgreSQL with pgvector for vector embeddings
       - Redis for caching
     - Tests interactions with external dependencies
     - Generates coverage reports

### 2. Infrastructure Tests (`infra-tests.yml`)

This workflow validates the development and deployment environment:

- **Triggers**:
  - Changes to Docker configuration
  - Changes to infrastructure code
  - Changes to setup scripts
  - Weekly scheduled runs to catch environmental drift

- **Jobs**:
  1. **Configuration Validation**
     - Validates docker-compose.yml
     - Checks .env.template for required variables
     - Ensures configuration files are properly formatted

  2. **Docker Environment Test**
     - Validates that the Docker Compose setup works correctly
     - Verifies all services start properly
     - Tests service health and interactions
     - Performs specific tests on the vector database

  3. **Setup Script Test**
     - Validates setup scripts for syntax errors
     - Checks for required components in setup scripts
     - Ensures scripts have appropriate permissions

## GitHub Actions Configuration

The GitHub Actions workflows are stored in the `.github/workflows/` directory:

- `code-tests.yml`: Tests for code quality and functionality
- `infra-tests.yml`: Tests for infrastructure and environment setup

## Directory Structure for Tests

Tests are organized into directories based on their type:

```
tests/
├── unit/              # Unit tests that don't require external services
├── integration/       # Tests that require external services
└── infrastructure/    # Tests for infrastructure components
```

## Running Tests Locally

To run the same tests locally that are run in the CI pipeline:

1. **Code Tests**:
   ```bash
   # Install dependencies
   poetry install

   # Run linting checks
   poetry run flake8 .
   poetry run black --check .
   poetry run isort --check .
   poetry run mypy .

   # Run unit tests
   poetry run pytest tests/unit

   # Run integration tests (requires running services)
   poetry run pytest tests/integration
   ```

2. **Infrastructure Tests**:
   ```bash
   # Validate Docker Compose configuration
   docker-compose config

   # Test Docker environment
   docker-compose up -d
   docker-compose ps
   docker-compose exec postgres pg_isready
   docker-compose exec vector_db pg_isready
   docker-compose exec redis redis-cli ping
   docker-compose down -v

   # Test setup scripts
   bash -n scripts/setup_dev.sh
   bash -n scripts/test-vector-db.sh
   ```

## Planned Expansions

The CI/CD pipeline will be extended in the future with additional workflows:

1. **AI-focused Testing Pipeline**
   - Vector database performance testing
   - Prompt template validation
   - Langfuse integration testing
   - AI model evaluation

2. **Security Scanning**
   - Dependency vulnerability scanning
   - Container security scanning
   - Code security analysis

3. **Deployment Pipelines**
   - Automatic staging deployments
   - Production deployment approval process
   - Deployment validation

4. **Self-Validating CI/CD**
   - Workflow validation
   - CI pipeline health monitoring
   - Test coverage reporting and enforcement

## Contributing to the CI/CD Pipeline

When making changes to the CI/CD pipeline:

1. Create a new branch for your changes
2. Test the workflow changes locally if possible
3. Document any new environment variables or secrets required
4. Update this documentation to reflect your changes
5. Submit a pull request for review

## Troubleshooting

If you encounter issues with the CI/CD pipeline:

1. Check the GitHub Actions logs for specific error messages
2. Verify that all required secrets and environment variables are set
3. Ensure your changes pass local tests before pushing
4. For infrastructure tests, check the uploaded docker-logs artifact if available
5. For code tests, review the coverage report to identify missed test cases
