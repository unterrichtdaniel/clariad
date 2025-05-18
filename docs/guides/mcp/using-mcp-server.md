# Using the Clariad MCP Server with Claude Desktop

This guide explains how to set up and use the Clariad MCP server with Claude Desktop to access specialized software development capabilities.

## Prerequisites

- Claude Desktop installed on your system
- Clariad installed and configured
- Basic understanding of software development concepts

## Setup and Configuration

### 1. Register the MCP Server

To register the Clariad MCP server with Claude Desktop, run the registration script:

```bash
cd /path/to/clariad
./scripts/register_mcp.sh
```

This script will:
- Locate your Claude Desktop configuration file
- Add the Clariad MCP server configuration to it
- Configure the server to launch with the correct parameters

### 2. Restart Claude Desktop

After registering the MCP server, you must restart Claude Desktop for the changes to take effect.

### 3. Verify Setup

To verify that Clariad is properly configured with Claude Desktop:

1. Open Claude Desktop
2. Type a message like "What capabilities does Clariad provide?"
3. Claude should respond by listing the available Clariad tools

## Using Clariad Agents

Once configured, you can use Clariad's specialized agents through Claude Desktop's interface. Here are some common usage patterns:

### Creating a Vision & Scope Document

To create a vision and scope document for a project:

1. Describe your project to Claude
2. Ask Claude to create a vision and scope document for it
3. Claude will invoke the Vision & Scope Agent to generate the document

Example prompt:
```
I have an idea for a project: a task management system that uses AI to prioritize tasks based on user behavior and deadlines. Could you create a vision and scope document for this project using Clariad?
```

### Designing System Architecture

To design system architecture for a project:

1. Provide project requirements to Claude
2. Ask Claude to design an architecture for the project
3. Claude will invoke the Architecture Agent to generate architecture documents and ADRs

Example prompt:
```
Based on the vision document we created, could you design the system architecture for this task management application? I'd like it to be a web app with a React frontend and Python backend.
```

### Continuous Context

Clariad maintains context between different agent invocations. This means that:

1. The Architecture Agent can use context from the Vision & Scope document
2. The Task Refinement Agent can use context from architecture documents
3. And so on through the development lifecycle

You don't need to repeat information that was already provided in previous steps.

## Long-Running Operations

Some Clariad operations may take a significant amount of time to complete. In these cases:

1. Claude will indicate that the operation is in progress
2. You'll receive streaming updates on the progress
3. Claude will incorporate the final results once the operation is complete

Example of a long-running operation:
```
Could you analyze the entire codebase of my project and identify potential architectural improvements?
```

## Troubleshooting

### MCP Server Not Appearing

If the Clariad tools don't appear in Claude Desktop:

1. Verify the registration with:
   ```bash
   cat ~/Library/Application\ Support/Claude/claude_desktop_config.json
   ```
2. Check that the "clariad" entry is correctly configured
3. Ensure that you've restarted Claude Desktop after registration
4. Check for errors in the Clariad logs

### Error in Tool Invocation

If you encounter errors when Claude tries to use Clariad tools:

1. Make sure the Clariad server is running and properly installed
2. Check that the virtual environment is correctly activated
3. Verify that all dependencies are installed with `poetry install`
4. Check for error messages in the Clariad logs

## Advanced Usage

### Custom Conversation IDs

For complex projects, you can explicitly specify conversation IDs to organize context:

```
Using the conversation ID "e-commerce-project", could you create a vision document for an e-commerce platform that specializes in handmade crafts?
```

Later, you can reference the same conversation:

```
Using the same conversation ID "e-commerce-project", design the architecture for this e-commerce platform.
```

### Running MCP Server Manually

For debugging or advanced usage, you can run the MCP server manually:

```bash
cd /path/to/clariad
poetry run python -m src.clariad.mcp.server
```

This will start the server and allow you to directly send JSON-RPC requests to it.

---

*Document Status: Active*
*Last Updated: May 19, 2025*
*Created By: Documentation Team*
*Version: 1.0*
