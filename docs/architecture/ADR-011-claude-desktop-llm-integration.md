# ADR-011: Claude Desktop LLM Integration

## Status

Accepted

## Context

Clariad is designed as an MCP extension for Claude Desktop and similar MCP-compatible clients. We need to determine how Clariad should interact with the underlying LLM capability, particularly whether it should establish its own direct connections to LLM providers or leverage the existing LLM connection already established by the Claude Desktop app.

## Decision

We will implement Clariad as a true MCP extension that leverages the existing LLM connection in Claude Desktop rather than establishing separate LLM connections for each agent.

## Alternatives Considered

1. **Direct LLM Connections**: Each agent or the orchestrator connects directly to LLM providers via API.
   - Pros: Independent control over model selection, potential for using different specialized models per agent.
   - Cons: Redundant connections, additional API costs, authentication complexity, disconnected from the Claude Desktop experience.

2. **Centralized LLM Service within Clariad**: A single internal service that all agents use to interact with LLM providers.
   - Pros: Unified control, single authentication point, consistent model usage.
   - Cons: Still duplicates the connection already established by Claude Desktop, requires separate API keys and billing.

3. **Leverage Claude Desktop's LLM**: Use the existing Claude Desktop connection for all LLM functionality.
   - Pros: Efficiency, no additional API costs, simplified architecture, true extension model, consistent user experience.
   - Cons: Limited to capabilities of the connected Claude model, potential constraints in parallelization.

## Decision Drivers

1. **Extension Philosophy**: True extensions should leverage existing components rather than duplicate them.
2. **Cost Efficiency**: No need for additional API usage costs beyond the Claude Desktop subscription.
3. **Authentication Simplicity**: No management of separate API keys required.
4. **User Experience**: Maintain consistency with the Claude Desktop experience.
5. **Implementation Simplicity**: Reduce complexity by leveraging the existing LLM connection.

## Consequences

### Positive

- No additional API costs beyond the Claude Desktop subscription
- Simplified architecture with no need for separate LLM authentication
- True extension model rather than a parallel system
- Consistent user experience within Claude Desktop
- Reduced implementation complexity

### Negative

- Limited to the capabilities of the Claude model connected to Desktop
- Potential bottlenecks if multiple agents need LLM processing simultaneously
- Need for efficient context management to work within Claude's context window
- Sequential rather than parallel operation for most agent tasks

## Implementation Notes

- Implement Clariad as an MCP server that communicates via standard input/output (stdio) with Claude Desktop
- Register the MCP server in the claude_desktop_config.json file with appropriate launch configuration
- Design specialized agents as MCP tools that Claude can invoke when needed during a conversation
- Each tool should have a clear name, description, and parameter schema following the MCP protocol
- Use the semantic memory system to efficiently manage context between agent invocations
- Implement a priority system for handling multiple agent tasks through the single LLM connection
- Ensure all agent prompts are optimized for the specific Claude model in use
- Maintain an efficient context window usage strategy to work within Claude's limitations
- Focus on stateless tool design where possible, using the semantic memory for continuity

For a complete technical reference on MCP implementation, see the [Desktop Commander MCP Technical Reference](../references/Desktop_Commander_MCP_Technical_Reference.md), which provides detailed insights into how a successful MCP server interacts with Claude Desktop.

## Related Decisions

- ADR-001: Multi-Agent System Architecture
- ADR-004: MCP Protocol Integration
- ADR-003: Semantic Memory with Vector Database