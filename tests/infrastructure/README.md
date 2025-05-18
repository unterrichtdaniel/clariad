# Infrastructure Tests

This directory contains infrastructure tests for the Clariad project. Infrastructure tests verify that the development and deployment environment is correctly configured and functioning.

## Characteristics of Infrastructure Tests

- Test configuration files (docker-compose.yml, .env.template, etc.)
- Verify that scripts work correctly (setup_dev.sh, etc.)
- Check that required Docker images are available
- Ensure infrastructure components can work together
- Validate environment setup

## Running Infrastructure Tests

```bash
# Run all infrastructure tests
poetry run pytest tests/infrastructure

# Run with verbose output
poetry run pytest tests/infrastructure -v

# Run a specific test file
poetry run pytest tests/infrastructure/test_docker.py
```

Some tests require Docker to be installed and running. Tests will be skipped if Docker is not available.

## Adding New Infrastructure Tests

When adding new infrastructure tests:

1. Create a new file with a `test_` prefix
2. Use appropriate pytest fixtures for setup/teardown
3. Make tests skip gracefully if required components aren't available
4. Focus on validating configuration, not application logic

Example:

```python
# tests/infrastructure/test_example.py
import os
import pytest
import subprocess

@pytest.mark.skipif(not os.path.exists("/var/run/docker.sock"), reason="Docker not available")
def test_docker_config():
    # Test that a Docker configuration is valid
    # ...
```

## Relationship to GitHub Actions

These tests correspond to the `infra-tests.yml` GitHub Actions workflow, which runs whenever:

- Infrastructure files are changed (docker-compose.yml, Dockerfile, etc.)
- Setup scripts are modified
- On a weekly schedule to catch environmental drift

By running these tests locally before pushing changes, you can ensure that infrastructure changes won't break the CI pipeline.
