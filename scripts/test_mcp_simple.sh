#!/bin/bash
# Test the MCP server with a simple list_tools request

# Path to the MCP server module
SERVER_MODULE="src.clariad.mcp.server"

# Test request (all on one line)
TEST_REQUEST='{"jsonrpc": "2.0", "id": "test-1", "method": "list_tools"}'

echo "Testing Clariad MCP Server with a list_tools request"
echo "==================================================="
echo
echo "Request:"
echo "$TEST_REQUEST"
echo

# Run the server with the test input
echo "$TEST_REQUEST" | poetry run python -m "$SERVER_MODULE"

echo
echo "Test complete"
