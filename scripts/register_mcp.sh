#!/bin/bash
set -e

# Get the absolute path to the project directory
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Determine the Claude Desktop config path based on OS
if [[ "$OSTYPE" == "darwin"* ]]; then
  CONFIG_PATH="$HOME/Library/Application Support/Claude/claude_desktop_config.json"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  CONFIG_PATH="$HOME/.config/Claude/claude_desktop_config.json"
elif [[ "$OSTYPE" == "msys"* || "$OSTYPE" == "win32" ]]; then
  CONFIG_PATH="$APPDATA/Claude/claude_desktop_config.json"
else
  echo "Unsupported operating system"
  exit 1
fi

# Create the directory if it doesn't exist
mkdir -p "$(dirname "$CONFIG_PATH")"

# Check if the config file exists
if [ -f "$CONFIG_PATH" ]; then
  # Read the existing config
  CONFIG=$(cat "$CONFIG_PATH")
  # Check if the mcpServers section exists
  if [[ "$CONFIG" == *"\"mcpServers\""* ]]; then
    # Using a temporary file to modify the JSON
    TMP_FILE="$(mktemp)"
    echo "$CONFIG" | jq '.mcpServers.clariad = {"command": "poetry", "args": ["run", "python", "-m", "src.clariad.mcp.server"], "cwd": "'""'"}' > "$TMP_FILE"
    mv "$TMP_FILE" "$CONFIG_PATH"
  else
    # Add the mcpServers section
    TMP_FILE="$(mktemp)"
    echo "$CONFIG" | jq '. + {"mcpServers": {"clariad": {"command": "poetry", "args": ["run", "python", "-m", "src.clariad.mcp.server"], "cwd": "'""'"}}}' > "$TMP_FILE"
    mv "$TMP_FILE" "$CONFIG_PATH"
  fi
else
  # Create a new config file
  echo '{
  "mcpServers": {
    "clariad": {
      "command": "poetry",
      "args": ["run", "python", "-m", "src.clariad.mcp.server"],
      "cwd": "'""'"
    }
  }
}' > "$CONFIG_PATH"
fi

echo "Clariad MCP server registered with Claude Desktop at $CONFIG_PATH"
echo "Restart Claude Desktop to apply the changes."
