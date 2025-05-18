## Development Environment Setup

This guide explains how to set up your development environment for Clariad.

## Prerequisites

- Python 3.10+ with [Poetry](https://python-poetry.org/docs/#installation)
- [Docker](https://docs.docker.com/get-docker/) and [Docker Compose](https://docs.docker.com/compose/install/)

## Development Process

Before you begin development, please familiarize yourself with the following key process documents:

- [Definition of Done](/docs/process/definition-of-done.md) - Requirements for completing work items
- [Documentation Style Guide](/docs/documentation-style-guide.md) - Standards for all project documentation
- [Architecture Documentation](/docs/Architecture.md) - System design and component interactions

All contributions to Clariad should adhere to these standards.

## Initial Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/clariad.git
   cd clariad
   ```

2. Run the setup script:
   ```bash
   ./scripts/setup_dev.sh
   ```

   This script will:
   - Install dependencies with Poetry
   - Set up pre-commit hooks
   - Create a `.env` file from the template
   - Start all required Docker services

## Managing Environment Variables

The `.env` file is the single source of truth for all environment variables used in the project. To use these variables in your shell session:

**Bash/Zsh**:
```bash
source .env
```

**Fish**:
```fish
## Requires the bass plugin
bass source .env
```

## Docker Services

Clariad uses several Docker services:

- **PostgreSQL**: Main application database (port 5432)
- **PostgreSQL with pgvector**: Vector database for embeddings (port 5433)
- **Langfuse Web UI**: AI observability platform (port 3000)
- **Langfuse Worker**: Background processing for Langfuse (port 3030)
- **MinIO**: S3-compatible object storage (ports 9090, 9091)
- **Redis**: Caching and messaging (port 6379)
- **ClickHouse**: Analytics database (port 8123)

## Common Tasks

### Managing Docker Services

```bash
## View logs from all services
docker-compose logs -f

## View logs from a specific service
docker-compose logs -f vector_db

## Stop all services
docker-compose down

## Start all services
docker-compose up -d

## Restart a specific service
docker-compose restart vector_db
```

### Testing Vector Database

```bash
## Run the test script
./scripts/test-vector-db.sh
```

## Troubleshooting

### Docker Service Issues

If Docker services fail to start:

1. Check for port conflicts:
   ```bash
   docker-compose ps
   ```

2. View detailed logs:
   ```bash
   docker-compose logs
   ```

3. Try restarting with cleanup:
   ```bash
   docker-compose down -v  # Careful! This removes volumes
   docker-compose up -d
   ```

### Environment Variable Issues

If your application is not picking up environment variables:

1. Verify the variables are correctly defined in the `.env` file
2. Make sure you've sourced the `.env` file in your current shell session
3. Confirm that Docker Compose is using the environment variables:
   ```bash
   docker-compose config
   ```

---

*Document Status: Active*
*Last Updated: May 18, 2025*
*Created By: Development Team*
*Version: 1.1*
