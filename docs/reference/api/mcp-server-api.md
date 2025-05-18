# MCP Server API Reference

This document provides a comprehensive reference for the Clariad Model-Client Protocol (MCP) server API.

## Overview

The Clariad MCP server acts as an integration layer between Claude Desktop and the specialized AI agents in the Clariad ecosystem. It implements the Model-Client Protocol which allows Claude Desktop to discover and invoke Clariad's capabilities as tools.

## Connection and Setup

The MCP server communicates with Claude Desktop via standard input/output (stdio) streams. The connection is established when Claude Desktop launches the server executable specified in the `claude_desktop_config.json` file.

This connection configuration is handled by the registration script (`scripts/register_mcp.sh`).

## Protocol

The MCP server implements the JSON-RPC 2.0 protocol for communication with Claude Desktop. All messages are JSON objects exchanged over the stdio connection.

### Request Format

```json
{
  "jsonrpc": "2.0",
  "id": "request-id",
  "method": "method-name",
  "params": {
    // Method-specific parameters
  }
}
```

### Response Format

```json
{
  "jsonrpc": "2.0",
  "id": "request-id",
  "result": {
    // Method-specific result
  }
}
```

### Error Response Format

```json
{
  "jsonrpc": "2.0",
  "id": "request-id",
  "error": {
    "code": -32700,
    "message": "Error message"
  }
}
```

## Methods

### `list_tools`

Lists all available tools that the MCP server provides.

**Request**:
```json
{
  "jsonrpc": "2.0",
  "id": "request-id",
  "method": "list_tools"
}
```

**Response**:
```json
{
  "jsonrpc": "2.0",
  "id": "request-id",
  "result": {
    "tools": [
      {
        "name": "vision_agent",
        "description": "Creates Vision & Scope documents to establish project requirements and goals",
        "parameters": {
          "type": "object",
          "properties": {
            "project_description": {
              "type": "string",
              "description": "Brief description of the project"
            },
            "conversation_id": {
              "type": "string",
              "description": "Optional ID to maintain context between conversations"
            }
          },
          "required": ["project_description"]
        }
      },
      // Additional tools...
    ]
  }
}
```

### `invoke_tool`

Invokes a specific tool with the provided parameters.

**Request**:
```json
{
  "jsonrpc": "2.0",
  "id": "request-id",
  "method": "invoke_tool",
  "params": {
    "name": "tool-name",
    "parameters": {
      // Tool-specific parameters
    }
  }
}
```

**Response** (standard):
```json
{
  "jsonrpc": "2.0",
  "id": "request-id",
  "result": {
    "output": "Tool result output"
  }
}
```

**Response** (streaming for long-running operations):

For long-running operations, the server sends multiple responses with progress updates:

```json
{
  "jsonrpc": "2.0",
  "id": "request-id",
  "result": {
    "output": "Operation progress message",
    "status": "in_progress"
  }
}
```

Followed by a final response when complete:

```json
{
  "jsonrpc": "2.0",
  "id": "request-id",
  "result": {
    "output": "Completed operation"
  }
}
```

## Available Tools

The MCP server provides the following tools:

### Vision & Scope Agent

**Name**: `vision_agent`

**Description**: Creates Vision & Scope documents to establish project requirements and goals

**Parameters**:
- `project_description` (string, required): Brief description of the project
- `conversation_id` (string, optional): ID to maintain context between conversations

### Architecture Agent

**Name**: `architecture_agent`

**Description**: Designs system architecture and creates Architecture Decision Records (ADRs)

**Parameters**:
- `project_name` (string, required): Name of the project
- `requirements` (string, required): Project requirements to consider for architecture
- `conversation_id` (string, optional): ID to maintain context between conversations

### Long Running Operation (Example)

**Name**: `long_running_operation`

**Description**: Example of a long-running operation with streaming updates

**Parameters**:
- `operation_name` (string, required): Name of the operation to perform
- `duration_seconds` (number, required): How long the operation should take in seconds

## Context Management

The MCP server maintains conversation context across tool invocations using the `conversation_id` parameter. This allows agents to be aware of previous interactions and maintain continuity.

When a tool is invoked with a particular `conversation_id`, the server:

1. Retrieves any existing context for that conversation ID
2. Provides this context to the tool during invocation
3. Updates the context with the results of the current invocation

This enables scenarios where one agent builds upon the output of another, such as the Architecture Agent using context from a previous Vision & Scope document.

## Error Handling

The MCP server uses standard JSON-RPC error codes:

| Code | Message | Meaning |
|------|---------|---------|
| -32700 | Parse error | Invalid JSON received |
| -32600 | Invalid request | Request is not a valid JSON-RPC object |
| -32601 | Method not found | Requested method does not exist |
| -32602 | Invalid params | Method parameters are invalid |
| -32603 | Internal error | Internal JSON-RPC error |

## Usage Examples

### List Available Tools

**Request**:
```json
{"jsonrpc": "2.0", "id": "tools-1", "method": "list_tools"}
```

### Invoke Vision Agent

**Request**:
```json
{
  "jsonrpc": "2.0",
  "id": "invoke-1",
  "method": "invoke_tool",
  "params": {
    "name": "vision_agent",
    "parameters": {
      "project_description": "An AI-powered task management system",
      "conversation_id": "project-123"
    }
  }
}
```

### Invoke Long-Running Operation

**Request**:
```json
{
  "jsonrpc": "2.0",
  "id": "invoke-2",
  "method": "invoke_tool",
  "params": {
    "name": "long_running_operation",
    "parameters": {
      "operation_name": "Complex Analysis",
      "duration_seconds": 10
    }
  }
}
```

---

*Document Status: Active*
*Last Updated: May 19, 2025*
*Created By: Documentation Team*
*Version: 1.0*
