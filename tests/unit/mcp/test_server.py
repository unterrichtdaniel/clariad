"""Unit tests for the MCP server module."""

import io
import json
from unittest import TestCase, mock

from clariad.mcp.server import MCPServer


class TestMCPServer(TestCase):
    """Test cases for the MCPServer class."""

    def setUp(self) -> None:
        """Set up test fixtures."""
        self.input_stream = io.StringIO()
        self.output_stream = io.StringIO()
        self.server = MCPServer(
            input_stream=self.input_stream, output_stream=self.output_stream
        )

    def test_list_tools(self) -> None:
        """Test that list_tools returns the correct tools."""
        request = {"jsonrpc": "2.0", "id": "test-1", "method": "list_tools"}
        response_str = self.server.handle_request(json.dumps(request))
        response = json.loads(response_str)

        self.assertEqual(response["jsonrpc"], "2.0")
        self.assertEqual(response["id"], "test-1")
        self.assertIn("tools", response["result"])
        self.assertTrue(len(response["result"]["tools"]) > 0)

    def test_invoke_tool(self) -> None:
        """Test that invoke_tool works correctly."""
        request = {
            "jsonrpc": "2.0",
            "id": "test-2",
            "method": "invoke_tool",
            "params": {
                "name": "vision_agent",
                "parameters": {
                    "project_description": "Test Project",
                    "conversation_id": "test-convo-1",
                },
            },
        }
        response_str = self.server.handle_request(json.dumps(request))
        response = json.loads(response_str)

        self.assertEqual(response["jsonrpc"], "2.0")
        self.assertEqual(response["id"], "test-2")
        self.assertIn("output", response["result"])
        self.assertIn("Test Project", response["result"]["output"])

    def test_context_management(self) -> None:
        """Test context persistence between tool invocations."""
        # First request - Vision Agent
        request1 = {
            "jsonrpc": "2.0",
            "id": "test-context-1",
            "method": "invoke_tool",
            "params": {
                "name": "vision_agent",
                "parameters": {
                    "project_description": "Context Test Project",
                    "conversation_id": "test-context-convo",
                },
            },
        }
        self.server.handle_request(json.dumps(request1))

        # Second request - Architecture Agent with same conversation ID
        request2 = {
            "jsonrpc": "2.0",
            "id": "test-context-2",
            "method": "invoke_tool",
            "params": {
                "name": "architecture_agent",
                "parameters": {
                    "project_name": "Context Test",
                    "requirements": "Must maintain context",
                    "conversation_id": "test-context-convo",
                },
            },
        }
        response_str = self.server.handle_request(json.dumps(request2))
        response = json.loads(response_str)

        # Should reference the previous vision agent interaction
        self.assertIn("context", response["result"]["output"].lower())
        self.assertIn("previous interaction", response["result"]["output"].lower())

    def test_streaming_responses(self) -> None:
        """Test streaming responses for long-running operations."""
        # Let's patch the _handle_long_running_operation method directly
        # since that's easier to test than mocking time.sleep
        with mock.patch.object(
            self.server, "_handle_long_running_operation"
        ) as mock_handle:
            # Set up the mock to return a valid response
            mock_handle.return_value = json.dumps(
                {
                    "jsonrpc": "2.0",
                    "id": "test-streaming",
                    "result": {"output": "Completed operation: Test Operation"},
                }
            )

            request = {
                "jsonrpc": "2.0",
                "id": "test-streaming",
                "method": "invoke_tool",
                "params": {
                    "name": "long_running_operation",
                    "parameters": {
                        "operation_name": "Test Operation",
                        "duration_seconds": 0.5,
                    },
                },
            }

            # Call handle_request which should invoke our mocked method
            self.server.handle_request(json.dumps(request))

            # Check that our mock was called
            mock_handle.assert_called_once()

            # Check that it was called with the right arguments
            args, kwargs = mock_handle.call_args
            self.assertEqual(args[0]["id"], "test-streaming")
            self.assertEqual(args[1]["operation_name"], "Test Operation")

    def test_error_response_creation(self) -> None:
        """Test the error response creation method."""
        response_str = self.server._create_error_response(
            "test-error-id", -32603, "Test error message"
        )
        response = json.loads(response_str)

        self.assertEqual(response["jsonrpc"], "2.0")
        self.assertEqual(response["id"], "test-error-id")
        self.assertIn("error", response)
        self.assertEqual(response["error"]["code"], -32603)
        self.assertEqual(response["error"]["message"], "Test error message")

    def test_invalid_method(self) -> None:
        """Test handling of invalid methods."""
        request = {"jsonrpc": "2.0", "id": "test-3", "method": "invalid_method"}
        response_str = self.server.handle_request(json.dumps(request))
        response = json.loads(response_str)

        self.assertEqual(response["jsonrpc"], "2.0")
        self.assertEqual(response["id"], "test-3")
        self.assertIn("error", response)
        self.assertEqual(response["error"]["code"], -32601)

    def test_invalid_json(self) -> None:
        """Test handling of invalid JSON."""
        request = "not valid json"
        response_str = self.server.handle_request(request)
        response = json.loads(response_str)

        self.assertEqual(response["jsonrpc"], "2.0")
        self.assertEqual(response["id"], "")
        self.assertIn("error", response)
        self.assertEqual(response["error"]["code"], -32700)

    def test_start_method(self) -> None:
        """Test the start method for processing input."""
        # Set up the input stream with a test request
        self.input_stream = io.StringIO(
            '{"jsonrpc": "2.0", "id": "start-test", "method": "list_tools"}\n'
        )
        self.output_stream = io.StringIO()

        # Create a new server with our test streams
        test_server = MCPServer(
            input_stream=self.input_stream, output_stream=self.output_stream
        )

        # Mock the sys.stdin.readline to control when to stop the server
        with mock.patch.object(test_server.input_stream, "__iter__") as mock_iter:
            # Make __iter__ return an iterator that provides our line once then stops
            mock_iter.return_value = iter(
                ['{"jsonrpc": "2.0", "id": "start-test", "method": "list_tools"}\n']
            )

            # Call the start method
            test_server.start()

            # Check the output
            output = self.output_stream.getvalue()
            self.assertIn("jsonrpc", output)
            self.assertIn("start-test", output)
            self.assertIn("tools", output)
