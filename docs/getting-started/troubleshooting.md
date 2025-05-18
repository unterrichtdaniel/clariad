# Troubleshooting Guide

This document provides solutions for common issues you might encounter when using Clariad.

## Claude Desktop Integration Issues

### Clariad Tools Not Appearing in Claude Desktop

If Clariad tools don't appear in Claude Desktop:

1. **Check Configuration File**:
   - Verify the `claude_desktop_config.json` file exists in the correct location
   - Confirm the file contains the proper MCP server configuration:
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

2. **Verify Node.js Installation**:
   - Ensure Node.js is installed (v18 or higher)
   - Confirm it's accessible in your PATH:
   ```bash
   node --version
   ```

3. **Check Clariad MCP Server**:
   - Verify that @clariad/mcp-server is installed:
   ```bash
   npm list -g @clariad/mcp-server
   ```
   - Try reinstalling if needed:
   ```bash
   npm install -g @clariad/mcp-server
   ```

4. **Restart Claude Desktop**:
   - Completely close and restart Claude Desktop
   - Check for any error messages in Claude Desktop

## Docker Services Issues

### Database Connection Errors

If you encounter database connection errors:

1. **Check Service Status**:
   ```bash
   docker-compose ps
   ```

2. **Verify Connection Settings**:
   - Ensure your `.env` file has the correct database configuration
   - Check for port conflicts with other services

3. **Review Service Logs**:
   ```bash
   docker-compose logs postgres
   docker-compose logs vector_db
   ```

4. **Restart Services**:
   ```bash
   docker-compose restart postgres vector_db
   ```

### Vector Database Issues

If vector operations are failing:

1. **Verify Extension Installation**:
   ```bash
   docker-compose exec vector_db psql -U postgres -d vector_db -c "SELECT * FROM pg_extension WHERE extname = 'vector';"
   ```

2. **Test Basic Vector Operations**:
   ```bash
   ./scripts/test-vector-db.sh
   ```

3. **Check Table Structure**:
   ```bash
   docker-compose exec vector_db psql -U postgres -d vector_db -c "\d embeddings"
   ```

## MCP Connection Issues

If Claude Desktop is unable to communicate with the Clariad MCP server:

1. **Check Permissions**:
   - Ensure Claude Desktop has permission to execute the MCP server
   - Verify any antivirus or security software isn't blocking the connection

2. **Test MCP Server Manually**:
   ```bash
   ./scripts/test_mcp.sh
   ```

3. **Check for Port Conflicts**:
   - Verify that no other services are using ports required by the MCP server

4. **Review Connection Logs**:
   - Look for any connection errors in the Claude Desktop logs or console

## GitHub Integration Issues

If GitHub integration is not working correctly:

1. **Verify GitHub Token**:
   - Ensure your GitHub token is set correctly in the `.env` file
   - Check that the token has the necessary permissions

2. **Check Network Connectivity**:
   - Verify that your network allows connections to GitHub's API
   - Check if a proxy is required for your network

3. **Test API Connection**:
   ```bash
   curl -H "Authorization: token YOUR_GITHUB_TOKEN" https://api.github.com/user
   ```

## Still Having Issues?

If you continue to experience problems:

1. **Check for Known Issues**:
   - Visit our GitHub repository's Issues page to see if others have reported similar problems

2. **Submit a Bug Report**:
   - Open a new issue with detailed information about your problem
   - Include error messages, logs, and steps to reproduce the issue

3. **Join Community Discussion**:
   - Ask for help in our community forum or chat channel

---

*Document Status: Active*
*Last Updated: May 18, 2025*
*Created By: Documentation Team*
*Version: 1.0*
