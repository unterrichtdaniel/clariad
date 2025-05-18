# Getting Started with Clariad

This guide will help you set up and start using the Clariad AI Agent Ecosystem with Claude Desktop.

## Prerequisites

- [Claude Desktop](https://claude.ai/download) (latest version)
- Node.js (v18 or higher)
- Git
- GitHub account with appropriate repository access

## Installation

### 1. Install Clariad

```bash
# Install Clariad using npm
npm install -g @clariad/mcp-server
```

### 2. Configure Claude Desktop

Configure Claude Desktop to use Clariad by modifying the claude_desktop_config.json file:

**On macOS**:
```bash
# Open configuration file
nano ~/Library/Application\ Support/Claude/claude_desktop_config.json
```

**On Windows**:
```bash
# Open configuration file (PowerShell)
notepad $env:APPDATA\Claude\claude_desktop_config.json
```

**On Linux**:
```bash
# Open configuration file
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

For developers interested in the technical details of how MCP servers interact with Claude Desktop, see the [Desktop Commander MCP Technical Reference](./references/Desktop_Commander_MCP_Technical_Reference.md) document.

## Using Clariad

Once configured, you can access Clariad's capabilities by asking Claude to perform software development tasks. The MCP tool icon should appear in the Claude Desktop interface when Clariad's tools are available.

### Example Usage Patterns

#### Project Initialization

```
I want to create a new web application for task management. Can you help me design this project using Clariad?
```

#### Architecture Design

```
Design the architecture for a REST API service that manages user authentication and task tracking.
```

#### Task Refinement

```
Break down the user authentication feature into specific user stories with acceptance criteria.
```

#### Development

```
Implement the user registration functionality based on the acceptance criteria we defined.
```

#### Code Review

```
Review the code implementation for the user registration feature and suggest improvements.
```

### Operation Modes

Clariad supports two primary operation modes:

1. **Interactive Mode**: Step-by-step collaboration where you guide the process and make decisions at each phase.

2. **Autonomous Mode**: Clariad automatically steps through the entire development workflow with minimal intervention, pausing only at defined checkpoints.

To select autonomous mode:
```
Please run Clariad in autonomous mode to develop the complete task management application based on our requirements.
```

## Troubleshooting

### Clariad Tools Not Appearing

If the Clariad tools don't appear in Claude Desktop:

1. Verify that Claude Desktop is properly configured with the correct claude_desktop_config.json
2. Ensure Node.js is installed and accessible from the command line
3. Check that @clariad/mcp-server is installed globally
4. Restart Claude Desktop

### Common Issues

- **Permission Issues**: Ensure Claude Desktop has the necessary permissions to execute the Clariad MCP server
- **Network Issues**: Verify that GitHub API requests are not being blocked by firewalls or network policies
- **Configuration Errors**: Double-check the claude_desktop_config.json format for syntax errors

For additional support, please check the [Troubleshooting Guide](./troubleshooting.md) or open an issue on our GitHub repository.

## Next Steps

- Explore the [Architecture Documentation](./Architecture.md) to understand how Clariad's components work together
- Review the [OKRs](./OKRs.md) to understand the project's goals and vision
- Check the [User Stories](./user_stories/README.md) for detailed functionality descriptions

---

*Document Status: Active*
*Last Updated: May 17, 2025*
*Version: 1.0*
