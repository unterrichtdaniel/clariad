#!/bin/bash
set -e

# Run all tests with coverage
poetry run pytest --cov=src tests/

# Generate HTML coverage report
poetry run pytest --cov=src --cov-report=html tests/

echo "Tests completed. HTML coverage report available in htmlcov/ directory."
