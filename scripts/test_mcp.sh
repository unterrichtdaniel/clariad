#!/bin/bash
set -e

echo "Starting manual MCP server test..."
echo "Enter JSON-RPC requests to test the server. Press Ctrl+C to exit."
echo "Example request: {\"jsonrpc\": \"2.0\", \"id\": \"1\", \"method\": \"list_tools\"}"
echo ""

# Run the MCP server and interact with it
poetry run python -m src.clariad.mcp.server
