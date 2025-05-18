#!/bin/bash
# Test the MCP server with a tool invocation request

# Path to the MCP server module
SERVER_MODULE="src.clariad.mcp.server"

# Test request
TEST_REQUEST='{"jsonrpc": "2.0", "id": "test-2", "method": "invoke_tool", "params": {"name": "vision_agent", "parameters": {"project_description": "An AI-powered task management system"}}}'

echo "Testing Clariad MCP Server with a tool invocation request"
echo "======================================================"
echo
echo "Request:"
echo "$TEST_REQUEST"
echo

# Run the server with the test input
echo "$TEST_REQUEST" | poetry run python -m "$SERVER_MODULE"

echo
echo "Test complete"
