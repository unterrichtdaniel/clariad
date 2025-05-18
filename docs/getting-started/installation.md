# Installation

This guide will help you set up the Clariad AI Agent Ecosystem with Claude Desktop.

## Prerequisites

- [Claude Desktop](https://claude.ai/download) (latest version)
- Node.js (v18 or higher)
- Git
- GitHub account with appropriate repository access

## Installation Steps

### 1. Install Clariad

```bash
## Install Clariad using npm
npm install -g @clariad/mcp-server
```

### 2. Configure Claude Desktop

Configure Claude Desktop to use Clariad by modifying the claude_desktop_config.json file:

**On macOS**:
```bash
## Open configuration file
nano ~/Library/Application\ Support/Claude/claude_desktop_config.json
```

**On Windows**:
```bash
## Open configuration file (PowerShell)
notepad $env:APPDATA\Claude\claude_desktop_config.json
```

**On Linux**:
```bash
## Open configuration file
nano ~/.config/Claude/claude_desktop_config.json
```

Add the following configuration:

```json
{
  "mcpServers": {
    "clariad": {
      "command": "npx",
      "args": [
        "-y",
        "@clariad/mcp-server"
      ]
    }
  }
}
```

### 3. Restart Claude Desktop

Close and restart Claude Desktop to apply the configuration changes.

## How Clariad Works with Claude Desktop

Clariad operates as a Model-Client Protocol (MCP) server that communicates with Claude Desktop through standard input/output (stdio). When you configure Claude Desktop to use Clariad:

1. Claude Desktop launches the Clariad MCP server when it starts
2. The MCP server registers specialized AI agents as tools that Claude can use
3. When you ask Claude to perform a software development task, Claude determines which Clariad tool to use
4. Claude sends a tool request to the Clariad MCP server via the stdio channel
5. Clariad processes the request through the appropriate specialized agent
6. Results are returned to Claude, which incorporates them into its response to you

This architecture ensures that Clariad leverages Claude's existing LLM capabilities rather than establishing separate connections, resulting in a seamless and efficient experience.

For developers interested in the technical details of how MCP servers interact with Claude Desktop, see the [Desktop Commander MCP Reference](/docs/reference/desktop-commander-mcp-reference.md) document.

## Verification

To verify that Clariad is properly installed and configured:

1. Open Claude Desktop
2. Type "Hello, can you use Clariad?"
3. Claude should respond by indicating that it has access to Clariad tools

If Claude indicates that it doesn't have access to Clariad, check the [Troubleshooting Guide](troubleshooting.md) for common issues and solutions.

## Next Steps

After successfully installing Clariad, you can:

- Read the [Quick Start Guide](quickstart.md) to begin using Clariad
- Explore the [Architecture Documentation](/docs/architecture/README.md) to understand how Clariad's components work together
- Check the [User Stories](/docs/user-stories/README.md) for detailed functionality descriptions

---

*Document Status: Active*
*Last Updated: May 18, 2025*
*Created By: Documentation Team*
*Version: 1.0*
