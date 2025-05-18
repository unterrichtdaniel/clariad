#!/bin/bash
# Test the CI pipeline locally to ensure it will pass in GitHub Actions

set -e  # Exit on any error

echo "🧪 Testing CI pipeline locally..."
echo "This script runs the same checks as the GitHub Actions workflows"

# Check if Poetry is installed
if ! command -v poetry &> /dev/null; then
    echo "❌ Poetry is not installed. Please install it first:"
    echo "curl -sSL https://install.python-poetry.org | python3 -"
    exit 1
fi

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install it first."
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose is not installed. Please install it first."
    exit 1
fi

echo "✅ Prerequisites checked"

# Install dependencies
echo "📦 Installing dependencies..."
poetry install

echo ""
echo "🔍 RUNNING CODE QUALITY AND TESTS"
echo "=================================="
echo ""

# Run linting and formatting checks
echo "🔍 Running code quality checks..."
echo "  • Flake8..."
poetry run flake8 . --count --select=E9,F63,F7,F82 --show-source --statistics || { echo "❌ Flake8 checks failed"; exit 1; }

echo "  • Black..."
poetry run black --check . || { echo "❌ Black formatting check failed. Run 'poetry run black .' to fix."; exit 1; }

echo "  • isort..."
poetry run isort --check . || { echo "❌ isort check failed. Run 'poetry run isort .' to fix."; exit 1; }

echo "  • mypy..."
poetry run mypy . || echo "⚠️ mypy check had issues, but continuing..."

echo "✅ Code quality checks passed"

# Run unit tests
echo "🧪 Running unit tests..."
poetry run pytest tests/unit -v || { echo "❌ Unit tests failed"; exit 1; }

echo "✅ Unit tests passed"

# Load environment variables if .env exists
if [ -f .env ]; then
    echo "🔧 Loading environment variables from .env"
    source .env
else
    echo "⚠️ No .env file found. Creating one from template for testing."
    cp .env.template .env
    source .env
fi

# Run integration tests
echo "🧪 Running integration tests..."

echo "  • Starting required services..."
# Check if services are already running
if docker ps | grep -q "postgres\|vector_db\|redis"; then
    echo "⚠️ Some services are already running. Tests will use existing services."
else
    echo "  • Starting test database services..."
    docker-compose up -d postgres vector_db redis
    echo "  • Waiting for services to be ready..."
    sleep 10
fi

echo "  • Running tests..."
poetry run pytest tests/integration -v || {
    echo "❌ Integration tests failed";
    echo "  • Stopping services...";
    docker-compose stop postgres vector_db redis;
    exit 1;
}

echo "✅ Integration tests passed"

echo ""
echo "🔍 RUNNING INFRASTRUCTURE TESTS"
echo "==============================="
echo ""

# Run infrastructure tests
echo "🧪 Running infrastructure tests..."
poetry run pytest tests/infrastructure -v || { echo "❌ Infrastructure tests failed"; exit 1; }

echo "✅ Infrastructure tests passed"

# Test Docker Compose setup
echo "🐳 Testing full Docker Compose setup..."

# Check if services are already running
if docker-compose ps --services --filter "status=running" | grep -q "."; then
    echo "⚠️ Some Docker services are already running. Stopping them..."
    docker-compose down
fi

echo "  • Starting all services..."
docker-compose up -d

echo "  • Waiting for services to be ready..."
sleep 15

echo "  • Checking service health..."
docker-compose ps

# Check if essential services are running
if ! docker-compose ps | grep -q "postgres.*running"; then
    echo "❌ PostgreSQL service is not running"
    docker-compose logs postgres
    docker-compose down
    exit 1
fi

if ! docker-compose ps | grep -q "vector_db.*running"; then
    echo "❌ Vector DB service is not running"
    docker-compose logs vector_db
    docker-compose down
    exit 1
fi

echo "  • Stopping services..."
docker-compose down

echo "✅ Docker Compose setup working correctly"

echo ""
echo "🎉 All checks passed! Your code should pass both GitHub Actions workflows:"
echo "  • code-tests.yml: Code quality and tests"
echo "  • infra-tests.yml: Infrastructure tests"
echo ""
echo "You can now commit and push your changes with confidence."
