# Integration Tests

This directory contains integration tests for the Clariad project. Integration tests verify that different components work together correctly and interact properly with external services.

## Characteristics of Integration Tests

- Test interaction between components
- Require external services (databases, Redis, etc.)
- Verify correct behavior of the system as a whole
- May be slower than unit tests
- Need proper setup and teardown of test environment

## Required Services

The integration tests in this directory typically require:

- PostgreSQL database
- PostgreSQL with pgvector extension
- Redis
- Other services defined in docker-compose.yml

## Running Integration Tests

```bash
# Start required services
docker-compose up -d postgres vector_db redis

# Run all integration tests
poetry run pytest tests/integration

# Run with verbose output
poetry run pytest tests/integration -v

# Run a specific test file
poetry run pytest tests/integration/test_database.py

# Stop services when done
docker-compose down
```

## Test Environment Variables

These tests require environment variables to be set. You can:

1. Source your `.env` file: `source .env`
2. Or set them manually:
   ```bash
   export POSTGRES_USER=postgres
   export POSTGRES_PASSWORD=postgres
   export POSTGRES_HOST=localhost
   export POSTGRES_PORT=5432
   export VECTOR_DB_USER=postgres
   export VECTOR_DB_PASSWORD=vectorpass
   export VECTOR_DB_HOST=localhost
   export VECTOR_DB_PORT=5433
   ```

## Adding New Integration Tests

When adding new integration tests:

1. Create a new file with a `test_` prefix
2. Use appropriate pytest fixtures for setup/teardown
3. Make sure tests clean up after themselves
4. Use markers to indicate external dependencies: `@pytest.mark.database`

Example:

```python
# tests/integration/test_example.py
import pytest

@pytest.mark.database
def test_database_interaction():
    # Test code that interacts with the database
    # ...
```
