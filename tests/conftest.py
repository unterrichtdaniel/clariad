import asyncio
import os
from asyncio import AbstractEventLoop
from typing import Any, Dict, Generator

import pytest
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()


@pytest.fixture(scope="session")  # type: ignore
def event_loop() -> Generator[AbstractEventLoop, None, None]:
    """Create an instance of the default event loop for each test case."""
    loop = asyncio.get_event_loop_policy().new_event_loop()
    yield loop
    loop.close()


@pytest.fixture(scope="session")  # type: ignore
def test_config() -> Dict[str, Any]:
    """Provide test configuration."""
    return {
        "postgres_connection_string": os.environ.get(
            "POSTGRES_CONNECTION_STRING",
            "postgresql://postgres:postgres@localhost:5432/clariad_test",
        ),
    }
