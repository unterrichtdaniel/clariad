# ADR-003: Semantic Memory with Vector Database

## Status

Accepted

## Context

The Clariad AI Agent Ecosystem requires a persistent memory system to store and retrieve contextual information across agent interactions. Agents need to access prior decisions, artifacts, and context to maintain continuity and make informed decisions.

## Decision

We will implement a semantic memory system using PostgreSQL with pgvector extension as the vector database, storing embeddings of documents and agent outputs for contextual retrieval.

## Alternatives Considered

1. **Simple Key-Value Store**: Using Redis or similar for basic state persistence.
   - Pros: Simplicity, performance.
   - Cons: Limited semantic search capabilities, no vector similarity search.

2. **Specialized Vector Databases**: Using Pinecone, Weaviate, or Milvus.
   - Pros: Purpose-built for vector search, performance optimized.
   - Cons: Additional service dependency, potential cost, less familiar to most developers.

3. **Document Databases**: Using MongoDB or similar.
   - Pros: Flexible schema, good for storing varied document types.
   - Cons: Limited native vector search capabilities without additional components.

4. **File-Based Storage**: Storing context directly in repository files.
   - Pros: Simplicity, no additional services.
   - Cons: Poor performance for semantic search, limited context retrieval capabilities.

## Decision Drivers

1. **Semantic Search**: Need to retrieve information based on meaning rather than exact matches.
2. **Persistence**: Requirement for durable storage across sessions.
3. **Integration**: Compatibility with LangChain/LangGraph ecosystem.
4. **Familiarity**: Using technology that is familiar to most developers.
5. **Scalability**: Ability to handle growing project knowledge and history.

## Consequences

### Positive

- Enables semantic search to find relevant context based on meaning
- Provides persistent storage of project knowledge
- Integrates well with LangChain's vector store abstractions
- PostgreSQL is a familiar, battle-tested database for most teams
- Scales well for anticipated usage patterns
- Single storage solution for both structured and vector data

### Negative

- Additional complexity in setting up and maintaining PostgreSQL with pgvector
- Requires management of embeddings generation and storage
- May become a performance bottleneck if not properly optimized
- Requires regular maintenance (index optimization, etc.)

## Implementation Notes

- PostgreSQL will be configured with the pgvector extension
- Document text will be embedded using appropriate embedding models
- Each agent output will be stored with metadata for retrieval
- Semantic search will be implemented to find relevant context for each agent
- The orchestrator will handle storing and retrieving information from the vector store
- Regular maintenance tasks will be scheduled for database optimization

## Related Decisions

- ADR-001: Multi-Agent System Architecture
- ADR-002: LangGraph as Orchestration Framework
- ADR-004: MCP Protocol Integration
