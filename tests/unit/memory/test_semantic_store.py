from typing import Any, Dict

from clariad.memory.semantic_store import SemanticMemory


class TestSemanticMemory:
    """Test cases for the SemanticMemory class."""

    def test_initialization(self, test_config: Dict[str, Any]) -> None:
        """Test that the memory store initializes correctly."""
        memory = SemanticMemory(test_config["postgres_connection_string"])
        assert memory is not None
