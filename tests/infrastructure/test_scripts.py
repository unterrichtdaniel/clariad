import os
import subprocess


def test_setup_script_exists() -> None:
    """Test that the setup script exists and is executable."""
    script_path = "./scripts/setup_dev.sh"
    assert os.path.exists(script_path), "setup_dev.sh script not found"
    assert os.access(script_path, os.X_OK), "setup_dev.sh is not executable"


def test_setup_script_syntax() -> None:
    """Test that the setup script has valid syntax."""
    script_path = "./scripts/setup_dev.sh"

    # Use bash's syntax checking
    process = subprocess.run(
        ["bash", "-n", script_path], capture_output=True, text=True
    )

    assert process.returncode == 0, f"setup_dev.sh has syntax errors: {process.stderr}"


def test_test_vector_db_script_exists() -> None:
    """Test that the vector DB test script exists and is executable."""
    script_path = "./scripts/test-vector-db.sh"
    assert os.path.exists(script_path), "test-vector-db.sh script not found"
    assert os.access(script_path, os.X_OK), "test-vector-db.sh is not executable"


def test_test_vector_db_script_syntax() -> None:
    """Test that the vector DB test script has valid syntax."""
    script_path = "./scripts/test-vector-db.sh"

    # Use bash's syntax checking
    process = subprocess.run(
        ["bash", "-n", script_path], capture_output=True, text=True
    )

    assert (
        process.returncode == 0
    ), f"test-vector-db.sh has syntax errors: {process.stderr}"


def test_scripts_have_required_components() -> None:
    """Test that scripts contain essential components."""
    setup_script_path = "./scripts/setup_dev.sh"

    with open(setup_script_path, "r") as f:
        setup_content = f.read()

    # Check for required elements in setup script
    required_components = ["docker-compose", "poetry install", ".env.template"]

    for component in required_components:
        assert (
            component in setup_content
        ), f"Required component '{component}' not found in setup_dev.sh"
