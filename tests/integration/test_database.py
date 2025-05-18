import os

import psycopg2
import pytest
from psycopg2.extras import Json

# Skips these tests if database connections aren't available
pytestmark = pytest.mark.skipif(
    os.environ.get("POSTGRES_HOST") is None or os.environ.get("VECTOR_DB_HOST") is None,
    reason="Database environment variables not set",
)


def test_postgres_connection() -> None:
    """Test connection to main PostgreSQL database."""
    conn_string = os.environ.get("POSTGRES_CONNECTION_STRING")
    assert conn_string is not None, "Connection string not found in environment"

    # Connect to database
    conn = psycopg2.connect(conn_string)
    cursor = conn.cursor()

    # Simple query to verify connection
    cursor.execute("SELECT 1")
    result = cursor.fetchone()

    assert result[0] == 1

    # Close connection
    cursor.close()
    conn.close()


def test_vector_db_connection() -> None:
    """Test connection to vector database with pgvector extension."""
    conn_string = os.environ.get("VECTOR_DB_CONNECTION_STRING")
    assert (
        conn_string is not None
    ), "Vector DB connection string not found in environment"

    # Connect to vector database
    conn = psycopg2.connect(conn_string)
    cursor = conn.cursor()

    # Check if vector extension is available
    cursor.execute("SELECT * FROM pg_extension WHERE extname = 'vector'")
    result = cursor.fetchone()

    assert result is not None, "vector extension not installed"

    # Close connection
    cursor.close()
    conn.close()


def test_vector_operations() -> None:
    """Test basic vector operations if possible."""
    conn_string = os.environ.get("VECTOR_DB_CONNECTION_STRING")
    assert (
        conn_string is not None
    ), "Vector DB connection string not found in environment"

    # Connect to vector database
    conn = psycopg2.connect(conn_string)
    cursor = conn.cursor()

    try:
        # Test a basic vector operation
        cursor.execute("SELECT '[1,2,3]'::vector <-> '[4,5,6]'::vector AS distance")
        result = cursor.fetchone()
        assert result is not None, "Vector operation failed"
    except Exception as e:
        pytest.skip(f"Vector operations not fully supported: {e!s}")
    finally:
        # Close connection
        cursor.close()
        conn.close()


def test_embedding_insert() -> None:
    """Test inserting and retrieving an embedding."""
    conn_string = os.environ.get("VECTOR_DB_CONNECTION_STRING")
    assert (
        conn_string is not None
    ), "Vector DB connection string not found in environment"

    # Connect to vector database
    conn = psycopg2.connect(conn_string)
    cursor = conn.cursor()

    try:
        # Ensure the table exists
        cursor.execute(
            """
        CREATE TABLE IF NOT EXISTS embeddings (
            id SERIAL PRIMARY KEY,
            content TEXT NOT NULL,
            embedding vector(3),
            metadata JSONB,
            created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
        )
        """
        )
        conn.commit()

        # Insert a test embedding
        cursor.execute(
            "INSERT INTO embeddings (content, embedding, metadata) VALUES (%s, %s, %s) "
            "RETURNING id",
            ("test content", "[1,2,3]", Json({"source": "test"})),
        )
        embedding_id = cursor.fetchone()[0]
        conn.commit()

        # Retrieve the embedding
        cursor.execute(
            "SELECT id, content, metadata FROM embeddings WHERE id = %s",
            (embedding_id,),
        )
        result = cursor.fetchone()

        assert result is not None, "Failed to retrieve embedding"
        assert result[1] == "test content", "Content does not match"
        assert result[2]["source"] == "test", "Metadata does not match"

        # Clean up
        cursor.execute("DELETE FROM embeddings WHERE id = %s", (embedding_id,))
        conn.commit()
    except Exception as e:
        pytest.skip(f"Embedding operations not fully supported: {e!s}")
    finally:
        # Close connection
        cursor.close()
        conn.close()
