# Clariad AI Agent Ecosystem

An intelligent AI-driven workflow assistant that integrates seamlessly into existing software development processes, ensuring clarity, precision, and accelerated productivity across all stages of software creation.

## About Clariad

Clariad is a modular, robust, and maintainable multi-agent AI ecosystem that embeds Agile, BDD/TDD, and architectural best practices into software development workflows. Designed as an MCP extension for Claude Desktop, the system enables frictionless collaboration between human developers and specialized AI agents through clear task definitions, architectural rigor, and effective feedback loops.

## Key Features

- **Comprehensive Agent Ecosystem**: 7 specialized AI agents (Vision & Scope, Architecture, Task Refinement, Development, Review, Deployment, Feedback) working in concert
- **GitHub Integration**: Seamless integration with GitHub repositories for artifact generation and management
- **Agile/BDD/TDD Focus**: Built-in adherence to software development best practices
- **Claude Desktop Integration**: Designed as an MCP extension that leverages Claude Desktop's existing LLM capabilities
- **Extensible Architecture**: Built with LangGraph and LangChain for maintainability and flexibility

## Getting Started

### Prerequisites

- Python 3.10+ with Poetry
- Docker and Docker Compose
- Claude Desktop

### Development Setup

1. Clone this repository:
```bash
git clone https://github.com/yourusername/clariad.git
cd clariad
```

2. Run the setup script:
```bash
./scripts/setup_dev.sh
```

This will:
- Install dependencies with Poetry
- Set up pre-commit hooks
- Create a `.env` file from the template
- Start the required Docker services (Postgres, Vector DB, Langfuse, etc.)

3. Configure Claude Desktop
4. Start a new conversation in Claude Desktop and begin using Clariad's specialized development tools

### Development Environment

The environment includes:
- PostgreSQL for primary database
- PostgreSQL with pgvector for vector database (embeddings)
- Langfuse for AI observability
- MinIO for object storage
- Redis for caching and messaging
- ClickHouse for analytics

For detailed installation and usage instructions, see the [Getting Started Guide](docs/getting-started/README.md).

## Documentation

- [Objectives and Key Results (OKRs)](docs/project/okrs.md) - Project vision and measurable objectives
- [Architecture](docs/architecture/README.md) - System architecture and design decisions
- [Vision and Scope](docs/project/vision-and-scope.md) - Detailed project vision and scope

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

© 2025 Clariad Project Team
