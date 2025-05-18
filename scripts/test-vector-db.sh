#!/bin/bash
set -e

# This script tests if the vector database is properly configured with pgvector
echo "🔍 Testing Vector Database Configuration"
echo "========================================"

# Load environment variables from .env file if it exists
if [ -f .env ]; then
    echo "📋 Loading environment variables from .env file..."
    source .env
fi

# Set default values if not loaded from .env
VECTOR_DB_USER=${VECTOR_DB_USER:-postgres}
VECTOR_DB_PASSWORD=${VECTOR_DB_PASSWORD:-vectorpass}
VECTOR_DB_HOST=${VECTOR_DB_HOST:-localhost}
VECTOR_DB_PORT=${VECTOR_DB_PORT:-5433}
VECTOR_DB_NAME=${VECTOR_DB_NAME:-vector_db}

# Check if we're running directly from Docker container
echo "🔄 Checking for Docker container access..."
if docker ps | grep -q "clariad-vector_db-1"; then
    echo "✅ Using Docker container for tests"
    echo "🔌 Testing connection to vector database..."
    docker exec -it clariad-vector_db-1 psql -U $VECTOR_DB_USER -d $VECTOR_DB_NAME -c "SELECT COUNT(*) FROM pg_extension WHERE extname = 'vector';"

    if [ $? -eq 0 ]; then
        echo "✅ Vector database is configured correctly with pgvector extension!"
    else
        echo "❌ Failed to connect to vector database or pgvector extension is not installed."
        echo "   Please check if the vector database container is running."
        exit 1
    fi

    # Test vector operations
    echo "🧪 Testing vector operations..."
    docker exec -it clariad-vector_db-1 psql -U $VECTOR_DB_USER -d $VECTOR_DB_NAME -c "SELECT '[1,2,3]'::vector <-> '[4,5,6]'::vector AS distance;"

    if [ $? -eq 0 ]; then
        echo "✅ Vector operations are working correctly!"
    else
        echo "❌ Vector operations failed."
        echo "   Please check if the pgvector extension is properly installed."
        exit 1
    fi

    # Test database operations
    echo "📊 Testing sample embedding insertion and retrieval..."
    docker exec -it clariad-vector_db-1 psql -U $VECTOR_DB_USER -d $VECTOR_DB_NAME << EOF
-- Insert a test embedding
INSERT INTO embeddings (content, embedding, metadata)
VALUES ('test content', '[0.1, 0.2, 0.3]', '{"source": "test"}');

-- Retrieve the test embedding
SELECT id, content, metadata, (embedding <-> '[0.1, 0.2, 0.3]')::numeric(10,6) AS distance
FROM embeddings
ORDER BY embedding <-> '[0.1, 0.2, 0.3]'
LIMIT 1;
EOF
else
    # Fall back to direct connection
    echo "🔌 Using direct connection to vector database..."
    export PGPASSWORD=$VECTOR_DB_PASSWORD
    psql -h $VECTOR_DB_HOST -p $VECTOR_DB_PORT -U $VECTOR_DB_USER -d $VECTOR_DB_NAME -c "SELECT COUNT(*) FROM pg_extension WHERE extname = 'vector';" > /dev/null

    if [ $? -eq 0 ]; then
        echo "✅ Vector database is configured correctly with pgvector extension!"
    else
        echo "❌ Failed to connect to vector database or pgvector extension is not installed."
        echo "   Please check if the vector database is running and properly configured."
        exit 1
    fi

    # Test vector operations
    echo "🧪 Testing vector operations..."
    psql -h $VECTOR_DB_HOST -p $VECTOR_DB_PORT -U $VECTOR_DB_USER -d $VECTOR_DB_NAME -c "SELECT '[1,2,3]'::vector <-> '[4,5,6]'::vector AS distance;" > /dev/null

    if [ $? -eq 0 ]; then
        echo "✅ Vector operations are working correctly!"
    else
        echo "❌ Vector operations failed."
        echo "   Please check if the pgvector extension is properly installed."
        exit 1
    fi

    # Test database operations
    echo "📊 Testing sample embedding insertion and retrieval..."
    psql -h $VECTOR_DB_HOST -p $VECTOR_DB_PORT -U $VECTOR_DB_USER -d $VECTOR_DB_NAME << EOF
-- Insert a test embedding
INSERT INTO embeddings (content, embedding, metadata)
VALUES ('test content', '[0.1, 0.2, 0.3]', '{"source": "test"}');

-- Retrieve the test embedding
SELECT id, content, metadata, (embedding <-> '[0.1, 0.2, 0.3]')::numeric(10,6) AS distance
FROM embeddings
ORDER BY embedding <-> '[0.1, 0.2, 0.3]'
LIMIT 1;
EOF
fi

if [ $? -eq 0 ]; then
    echo "✅ Database operations are working correctly!"
else
    echo "❌ Database operations failed."
    echo "   Please check if the embeddings table is properly created."
    exit 1
fi

echo ""
echo "🎉 Vector database is ready for use! 🎉"
echo ""
echo "📝 Connection information:"
echo "  • Host: $VECTOR_DB_HOST"
echo "  • Port: $VECTOR_DB_PORT"
echo "  • Database: $VECTOR_DB_NAME"
echo "  • User: $VECTOR_DB_USER"
echo ""
echo "🔗 Connection string: postgresql://$VECTOR_DB_USER:******@$VECTOR_DB_HOST:$VECTOR_DB_PORT/$VECTOR_DB_NAME"
echo ""
echo "💡 Example queries:"
echo "  • Create an embedding: INSERT INTO embeddings (content, embedding) VALUES ('text', '[0.1, 0.2, ...]');"
echo "  • Find similar embeddings: SELECT content FROM embeddings ORDER BY embedding <-> '[0.1, 0.2, ...]' LIMIT 5;"
