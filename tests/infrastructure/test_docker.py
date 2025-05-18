import os
import subprocess

import docker
import pytest


@pytest.mark.skipif(  # type: ignore
    not os.path.exists("/var/run/docker.sock"), reason="Docker not available"
)
def test_docker_compose_file() -> None:
    """Test that docker-compose.yml is valid."""
    # Run docker-compose config to validate the file
    process = subprocess.run(
        ["docker-compose", "config"], capture_output=True, text=True
    )

    # Check if the command was successful
    assert (
        process.returncode == 0
    ), f"Docker Compose validation failed: {process.stderr}"

    # Check that the output contains expected services
    output = process.stdout
    assert "postgres:" in output, "PostgreSQL service not found in docker-compose.yml"
    assert "vector_db:" in output, "Vector DB service not found in docker-compose.yml"


@pytest.mark.skipif(  # type: ignore
    not os.path.exists("/var/run/docker.sock"), reason="Docker not available"
)
def test_docker_images() -> None:
    """Test that required Docker images are available or can be pulled."""
    client = docker.from_env()

    # List of required images
    required_images = ["postgres:latest", "ankane/pgvector:latest", "redis:7"]

    for image_name in required_images:
        try:
            # Try to get the image
            client.images.get(image_name)
            print(f"Image {image_name} already exists")
        except docker.errors.ImageNotFound:
            # If not found, try to pull it
            print(f"Pulling image {image_name}...")
            try:
                client.images.pull(image_name)
                print(f"Successfully pulled {image_name}")
            except Exception as e:
                raise AssertionError(f"Failed to pull image {image_name}: {e!s}") from e


@pytest.mark.skipif(  # type: ignore
    not os.path.exists("/var/run/docker.sock"), reason="Docker not available"
)
def test_env_template() -> None:
    """Test that .env.template contains all required variables."""
    # Check if .env.template exists
    assert os.path.exists(".env.template"), ".env.template not found"

    # Read the file
    with open(".env.template", "r") as f:
        content = f.read()

    # Check for required variables
    required_vars = [
        "POSTGRES_USER=",
        "POSTGRES_PASSWORD=",
        "POSTGRES_HOST=",
        "POSTGRES_PORT=",
        "VECTOR_DB_USER=",
        "VECTOR_DB_PASSWORD=",
        "VECTOR_DB_HOST=",
        "VECTOR_DB_PORT=",
    ]

    for var in required_vars:
        assert var in content, f"Required variable {var} not found in .env.template"
