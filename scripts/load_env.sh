#!/bin/bash
# Helper script to load environment variables

# Check if .env file exists
if [ ! -f .env ]; then
    echo "❌ .env file not found. Please run ./scripts/setup_dev.sh first."
    exit 1
fi

# Print a message to remind users to source this file
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "❌ This script must be sourced, not executed."
    echo "Usage: source ./scripts/load_env.sh"
    exit 1
fi

# Source the .env file
source .env

# Print confirmation
echo "✅ Environment variables loaded from .env"
echo "Variables available in this shell session:"
echo "  • POSTGRES_USER: $POSTGRES_USER"
echo "  • POSTGRES_HOST: $POSTGRES_HOST"
echo "  • POSTGRES_PORT: $POSTGRES_PORT"
echo "  • VECTOR_DB_HOST: $VECTOR_DB_HOST"
echo "  • VECTOR_DB_PORT: $VECTOR_DB_PORT"
echo "  • LANGFUSE_HOST: $LANGFUSE_HOST"
echo ""
echo "To use these variables in your code:"
echo "  • Python: os.environ.get('VARIABLE_NAME')"
echo "  • Shell: \$VARIABLE_NAME"
