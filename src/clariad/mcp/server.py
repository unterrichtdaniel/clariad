"""
Model-Client Protocol (MCP) server for Clariad.

This module implements an MCP server that registers specialized agents as tools
that Claude Desktop can invoke during conversations.
"""

import json
import logging
import sys
import time
from typing import Any, Dict, List, TextIO

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
    handlers=[logging.StreamHandler(sys.stderr)],
)
logger = logging.getLogger("clariad.mcp")

# Define MCP server constants
JSONRPC_VERSION = "2.0"


class MCPServer:
    """Model-Client Protocol server implementation for Clariad."""

    def __init__(
        self, input_stream: TextIO = sys.stdin, output_stream: TextIO = sys.stdout
    ) -> None:
        """Initialize the MCP server.

        Args:
            input_stream: The input stream to read requests from.
            output_stream: The output stream to write responses to.
        """
        self.tools = self._register_tools()
        self.input_stream = input_stream
        self.output_stream = output_stream
        self.context_store: Dict[str, Any] = {}  # Store for conversation context
        logger.info(f"Initialized MCP server with {len(self.tools)} tools")

    def _register_tools(self) -> List[Dict[str, Any]]:
        """Register all available tools with the MCP server.

        Returns:
            List of tool definitions that can be used by Claude Desktop.
        """
        # TODO: Implement real agent tools
        return [
            {
                "name": "vision_agent",
                "description": "Creates Vision & Scope docs for projects",
                "parameters": {
                    "type": "object",
                    "properties": {
                        "project_description": {
                            "type": "string",
                            "description": "Brief description of the project",
                        },
                        "conversation_id": {
                            "type": "string",
                            "description": "Optional ID for conversation context",
                        },
                    },
                    "required": ["project_description"],
                },
            },
            {
                "name": "architecture_agent",
                "description": "Designs system architecture and creates ADRs",
                "parameters": {
                    "type": "object",
                    "properties": {
                        "project_name": {
                            "type": "string",
                            "description": "Name of the project",
                        },
                        "requirements": {
                            "type": "string",
                            "description": "Project requirements for architecture",
                        },
                        "conversation_id": {
                            "type": "string",
                            "description": "Optional ID for conversation context",
                        },
                    },
                    "required": ["project_name", "requirements"],
                },
            },
            {
                "name": "long_running_operation",
                "description": "Example of a long-running operation with updates",
                "parameters": {
                    "type": "object",
                    "properties": {
                        "operation_name": {
                            "type": "string",
                            "description": "Name of the operation to perform",
                        },
                        "duration_seconds": {
                            "type": "number",
                            "description": "Duration of the operation in seconds",
                        },
                    },
                    "required": ["operation_name", "duration_seconds"],
                },
            },
        ]

    def handle_request(self, request_str: str) -> str:
        """Handle an incoming MCP request.

        Args:
            request_str: The raw JSON-RPC request string.

        Returns:
            A JSON-RPC response string.
        """
        try:
            request = json.loads(request_str)
            logger.info(f"Received request: {request.get('method')}")

            # Handle the request based on the method
            if request.get("method") == "list_tools":
                return self._handle_list_tools(request)
            elif request.get("method") == "invoke_tool":
                return self._handle_invoke_tool(request)
            else:
                return self._create_error_response(
                    request.get("id", ""), -32601, "Method not found"
                )
        except json.JSONDecodeError:
            logger.error(f"Invalid JSON in request: {request_str}")
            return self._create_error_response("", -32700, "Parse error")
        except Exception as e:
            logger.error(f"Error handling request: {e}")
            return self._create_error_response("", -32603, str(e))

    def _handle_list_tools(self, request: Dict[str, Any]) -> str:
        """Handle a list_tools request.

        Args:
            request: The parsed JSON-RPC request.

        Returns:
            A JSON-RPC response with the list of available tools.
        """
        response = {
            "jsonrpc": JSONRPC_VERSION,
            "id": request.get("id", ""),
            "result": {"tools": self.tools},
        }
        return json.dumps(response)

    def _handle_invoke_tool(self, request: Dict[str, Any]) -> str:
        """Handle an invoke_tool request.

        Args:
            request: The parsed JSON-RPC request.

        Returns:
            A JSON-RPC response with the tool invocation result.
        """
        # Extract tool name and parameters
        params = request.get("params", {})
        tool_name = params.get("name", "")
        tool_params = params.get("parameters", {})

        # Get conversation_id for context management if provided
        conversation_id = tool_params.get("conversation_id", "default")

        # Retrieve existing context if available
        context = self.context_store.get(conversation_id, {})

        logger.info(f"Invoking tool: {tool_name} with params: {tool_params}")
        logger.info(f"Using conversation context: {context}")

        # Handle special case for streaming updates demonstration
        if tool_name == "long_running_operation":
            return self._handle_long_running_operation(request, tool_params)

        # For other tools, process normally
        result = self._process_tool_invocation(tool_name, tool_params, context)

        # Update context with any new information
        self.context_store[conversation_id] = {
            **context,
            "last_tool": tool_name,
            "last_params": tool_params,
            f"{tool_name}_result": result,
            "last_updated": time.time(),
        }

        response = {
            "jsonrpc": JSONRPC_VERSION,
            "id": request.get("id", ""),
            "result": {"output": result},
        }
        return json.dumps(response)

    def _handle_long_running_operation(
        self, request: Dict[str, Any], params: Dict[str, Any]
    ) -> str:
        """Handle a long-running operation with streaming updates.

        Args:
            request: The parsed JSON-RPC request.
            params: The parameters for the long-running operation.

        Returns:
            The final JSON-RPC response.
        """
        operation_name = params.get("operation_name", "Unknown Operation")
        duration_seconds = float(params.get("duration_seconds", 5.0))

        # Cap duration for safety and ensure it's positive
        if duration_seconds > 30:
            duration_seconds = 30
        elif duration_seconds <= 0:
            duration_seconds = 1  # Minimum 1 second

        steps = min(max(int(duration_seconds), 1), 10)  # Between 1 and 10 steps
        interval = duration_seconds / steps

        # Send initial response
        self._send_stream_response(
            request.get("id", ""),
            f"Starting operation: {operation_name}",
            "in_progress",
        )

        # Simulate work with progress updates
        for i in range(1, steps + 1):
            # Pause to simulate work
            time.sleep(interval)

            # Calculate progress percentage
            progress = int((i / steps) * 100)

            # Send progress update
            self._send_stream_response(
                request.get("id", ""),
                f"Operation: {operation_name} - {progress}% complete",
                "in_progress",
            )

        # Send final response
        final_response = {
            "jsonrpc": JSONRPC_VERSION,
            "id": request.get("id", ""),
            "result": {"output": f"Completed operation: {operation_name}"},
        }

        return json.dumps(final_response)

    def _send_stream_response(self, request_id: str, message: str, status: str) -> None:
        """Send a streaming response for long-running operations.

        Args:
            request_id: The ID of the current request.
            message: The status message to send.
            status: The current status (e.g., 'in_progress', 'complete').
        """
        response = {
            "jsonrpc": JSONRPC_VERSION,
            "id": request_id,
            "result": {"output": message, "status": status},
        }

        self.output_stream.write(json.dumps(response) + "\n")
        self.output_stream.flush()
        logger.info(f"Sent streaming update: {message}")

    def _process_tool_invocation(
        self, tool_name: str, params: Dict[str, Any], context: Dict[str, Any]
    ) -> str:
        """Process a tool invocation with the given parameters and context.

        Args:
            tool_name: The name of the tool to invoke.
            params: The parameters for the tool invocation.
            context: The conversation context.

        Returns:
            The result of the tool invocation.
        """
        # TODO: Implement actual agent invocation logic
        # This is where we'd connect to the actual agent implementations

        if tool_name == "vision_agent":
            # Include context in the response if available
            previous_interaction = context.get("last_tool", "None")
            project_description = params.get("project_description", "")

            if previous_interaction:
                return (
                    f"Creating Vision & Scope document for: {project_description}.\n"
                    f"Using context from previous interaction: {previous_interaction}"
                )
            else:
                return f"Creating Vision & Scope document for: {project_description}"

        elif tool_name == "architecture_agent":
            project_name = params.get("project_name", "")
            # We capture requirements but don't use it in this simplified example
            _ = params.get("requirements", "")

            # Check if we have related Vision document in context
            vision_result = context.get("vision_agent_result", "")

            if vision_result:
                return (
                    f"Designing architecture for {project_name}.\n"
                    f"Using context from Vision document: {vision_result[:100]}..."
                )
            else:
                return f"Designing architecture for {project_name}"

        # Default response for unimplemented tools
        return f"Processed {tool_name} with parameters {params}"

    def _create_error_response(self, request_id: str, code: int, message: str) -> str:
        """Create a JSON-RPC error response.

        Args:
            request_id: The ID of the request that caused the error.
            code: The error code.
            message: The error message.

        Returns:
            A JSON-RPC error response string.
        """
        response = {
            "jsonrpc": JSONRPC_VERSION,
            "id": request_id,
            "error": {"code": code, "message": message},
        }
        return json.dumps(response)

    def start(self) -> None:
        """Start the MCP server and begin processing requests.

        This method reads requests from stdin and writes responses to stdout,
        following the MCP protocol.
        """
        logger.info("Starting Clariad MCP server")
        try:
            # Process requests until EOF
            for line in self.input_stream:
                line = line.strip()
                if not line:
                    continue

                response = self.handle_request(line)
                self.output_stream.write(response + "\n")
                self.output_stream.flush()
        except KeyboardInterrupt:
            logger.info("Server stopped by user")
        except Exception as e:
            logger.error(f"Unexpected error: {e}")


def main() -> None:
    """Run the MCP server."""
    server = MCPServer()
    server.start()


if __name__ == "__main__":
    main()
