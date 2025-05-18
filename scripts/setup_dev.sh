#!/bin/bash
set -e

# Print welcome message
echo "====================================================="
echo "Setting up Clariad development environment..."
echo "====================================================="

# Install poetry dependencies
echo "🔧 Installing Poetry dependencies..."
poetry install

# Setup pre-commit hooks
echo "🪝 Setting up pre-commit hooks..."
poetry run pre-commit install

# Create .env file from template if it doesn't exist
if [ ! -f .env ]; then
  echo "📝 Creating .env file from template..."
  cp .env.template .env
  echo "Created .env file. Please update it with your specific configuration."
else
  echo "✅ .env file already exists"
fi

# Create scripts directory if it doesn't exist
if [ ! -d "./scripts" ]; then
  echo "📁 Creating scripts directory..."
  mkdir -p ./scripts
fi

# Ensure vector database init script exists
if [ ! -f "./scripts/init-vector-db.sql" ]; then
  echo "🔄 Creating vector database initialization script..."
  cat > ./scripts/init-vector-db.sql << 'EOL'
-- Enable the pgvector extension
CREATE EXTENSION IF NOT EXISTS vector;

-- Create a sample table for vector embeddings (modify as needed)
CREATE TABLE IF NOT EXISTS embeddings (
    id SERIAL PRIMARY KEY,
    content TEXT NOT NULL,
    embedding vector(1536), -- OpenAI embeddings are 1536 dimensions, adjust as needed
    metadata JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create an index for vector similarity search
CREATE INDEX IF NOT EXISTS embeddings_vector_idx ON embeddings USING ivfflat (embedding vector_l2_ops) WITH (lists = 100);

-- Grant permissions to the postgres user
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO postgres;
EOL
  echo "Created vector database initialization script."
fi

# Check for orphaned containers and remove them if needed
echo "🧹 Checking for orphaned containers..."
ORPHANS=$(docker ps -a --filter "name=clariad-langfuse-1\|clariad-langfuse-db-1\|clariad-pgadmin-1" --format "{{.Names}}")
if [ -n "$ORPHANS" ]; then
  echo "Found orphaned containers from previous configuration: $ORPHANS"
  echo "Removing orphaned containers..."
  docker-compose down --remove-orphans
  echo "Orphaned containers removed."
else
  echo "No orphaned containers found."
fi

# Start development services
echo "🚀 Starting Docker services..."
docker-compose up -d

# Wait for services to be available
echo "⏳ Waiting for services to be ready..."
sleep 10  # Increased wait time for services to fully initialize

# Test vector database connection
echo "🧪 Testing vector database connection..."
# Try to connect multiple times in case the vector_db service is not fully ready
MAX_ATTEMPTS=5
ATTEMPT=1
while [ $ATTEMPT -le $MAX_ATTEMPTS ]; do
  echo "Attempt $ATTEMPT of $MAX_ATTEMPTS..."
  if docker exec -it $(docker ps -q -f name=clariad-vector_db-1) psql -U postgres -d vector_db -c "SELECT 'vector database is working' AS status;" 2>/dev/null; then
    echo "✅ Vector database is working!"
    break
  fi
  if [ $ATTEMPT -eq $MAX_ATTEMPTS ]; then
    echo "⚠️ Could not connect to vector database after $MAX_ATTEMPTS attempts."
    echo "Please check the logs with 'docker logs clariad-vector_db-1'"
  else
    echo "Waiting for vector database to be ready..."
    sleep 5
  fi
  ATTEMPT=$((ATTEMPT+1))
done

echo ""
echo "✨ Development environment setup complete! ✨"
echo ""
echo "🔶 Available services:"
echo "  • PostgreSQL (main): localhost:5432"
echo "  • PostgreSQL (vector): localhost:5433"
echo "  • Langfuse Web UI: http://localhost:3000"
echo "  • Langfuse Worker: http://localhost:3030"
echo "  • MinIO Console: http://localhost:9091 (login: minio / miniosecret)"
echo "  • MinIO S3 API: http://localhost:9090"
echo "  • Redis: localhost:6379"
echo "  • ClickHouse: localhost:8123"
echo ""
echo "🔶 Next steps:"
echo "  1. Update the .env file with your specific configuration"
echo "  2. For vector database operations, use the connection string in your .env file"
echo "  3. To test vector operations, run: ./scripts/test-vector-db.sh"
echo ""
echo "🔷 Environment variables:"
echo "  To load environment variables in your shell session:"
echo "  • Bash/Zsh: source .env"
echo "  • Fish: source .env # Requires the 'bass' plugin"
echo ""
echo "🔷 Development services:"
echo "  To view logs:        docker-compose logs -f"
echo "  To stop services:    docker-compose down"
echo "  To restart:          docker-compose restart"
echo ""
echo "Happy developing! 🚀"
