# Unit Tests

This directory contains unit tests for the Clariad project. Unit tests focus on testing individual components in isolation, without requiring external services or dependencies.

## Characteristics of Unit Tests

- Fast to run (milliseconds per test)
- No external dependencies (databases, APIs, etc.)
- Test a single "unit" of code (function, class, module)
- Deterministic (same input always produces same output)

## Running Unit Tests

```bash
# Run all unit tests
poetry run pytest tests/unit

# Run with verbose output
poetry run pytest tests/unit -v

# Run a specific test file
poetry run pytest tests/unit/test_basic.py
```

## Adding New Unit Tests

When adding new unit tests:

1. Create a new file with a `test_` prefix
2. Write test functions with a `test_` prefix
3. Keep tests isolated and independent
4. Use mocks or stubs for external dependencies

Example:

```python
# tests/unit/test_example.py

def test_my_function():
    # Arrange
    input_value = 5

    # Act
    result = my_function(input_value)

    # Assert
    assert result == expected_value
```
