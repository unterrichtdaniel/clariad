# Clariad AI Agent Ecosystem: Architecture

## Overview & Context

The Clariad AI Agent Ecosystem is designed to create an intelligent, AI-driven workflow assistant that seamlessly integrates into software development processes. The system orchestrates specialized AI agents to guide a software project through all stages of development, ensuring clarity, precision, and accelerated productivity.

This architecture document describes the high-level technical design of the Clariad system, focusing on the key components, their interactions, and the critical decisions that shape the overall structure. The design prioritizes modularity, extensibility, and adherence to software engineering best practices.

## Architectural Constraints

Based on the Vision & Scope document and project requirements, the architecture must adhere to the following constraints:

1. **LLM Integration**: The system must leverage large language models for agent intelligence, working within their capabilities and limitations.
2. **GitHub Centricity**: All artifacts must be stored in GitHub repositories, with documentation in Markdown format.
3. **MCP Compatibility**: The system must interface with users through the Model-Client Protocol (MCP), supporting clients like Claude Desktop and OpenWebUI.
4. **Non-execution Environment**: Clariad doesn't execute code directly but integrates with existing CI/CD systems.
5. **Observability Requirements**: All agent actions must be traceable and monitored through Langfuse.
6. **Separation of Concerns**: Each agent must have a clearly defined responsibility aligned with a specific development phase.
7. **Platform Independence**: The core system must be language-agnostic, adaptable to different programming languages and frameworks.

## System Components & Responsibilities

The Clariad ecosystem consists of the following major components:

### 1. MCP Interface Layer

**Responsibility**: Provides the user-facing conversational interface to the Clariad system and communicates with Claude Desktop.

- Acts as the communication gateway between users and the agent ecosystem
- Implements the MCP server protocol for integration with Claude Desktop using standard input/output (stdio)
- Registers specialized agents as tools that Claude can invoke using the MCP tool registration format
- Tool registration includes:
  - Tool name/identifier (e.g., "vision_agent", "architecture_agent")
  - Tool description (explaining the agent's purpose to users)
  - Parameters schema (defining what input the agent requires)
  - Return format specification (structuring the agent's output)
- Handles streaming of agent responses back to the client
- Formats tool usage and other special operations for MCP clients
- Maintains a consistent interface between Claude Desktop and the agent ecosystem

For a detailed technical reference on MCP implementation with Claude Desktop, see [Desktop Commander MCP Technical Reference](./references/Desktop_Commander_MCP_Technical_Reference.md).

### 2. LangGraph Orchestrator

**Responsibility**: Coordinates the workflow between agents and manages the system's state.

- Implements the directed graph of agent nodes and their transitions
- Maintains shared state and memory context for inter-agent communication
- Handles conditional logic, branching, and looping for complex workflows
- Routes tool invocations from Claude Desktop to appropriate agents
- Manages execution mode (autonomous vs. conversational)

### 3. Specialized Agent Nodes

Each agent is an independent module with specific responsibilities:

**Vision & Scope Agent**:
- Establishes project requirements and clear goals
- Creates comprehensive Vision & Scope documents
- Identifies stakeholders, constraints, and success metrics

**Architecture Agent**:
- Designs system architecture and documents key decisions
- Creates Architecture Decision Records (ADRs)
- Validates technical approach against requirements

**Task Refinement Agent**:
- Breaks down work into well-defined user stories with BDD scenarios
- Ensures stories meet INVEST criteria and Definition of Ready
- Prioritizes and organizes the backlog

**Development Agent**:
- Implements code using TDD principles
- Generates tests first, followed by implementation
- Ensures code quality and documentation

**Review Agent**:
- Analyzes code changes for quality and correctness
- Verifies acceptance criteria fulfillment
- Ensures adherence to Definition of Done

**Deployment Agent**:
- Manages CI/CD pipeline configuration
- Ensures deployment readiness
- Handles versioning and release management

**Feedback Agent**:
- Analyzes results and provides retrospective analysis
- Detects architecture drift and technical debt
- Suggests improvements for future iterations

### 4. Semantic Memory System

**Responsibility**: Provides persistent storage and retrieval of project knowledge.

- Stores agent outputs as embeddings in a vector database
- Enables contextual retrieval of project information
- Supports semantic search for relevant artifacts
- Maintains project history and decision context

### 5. GitHub Integration Layer

**Responsibility**: Handles all interactions with GitHub repositories.

- Manages documentation creation and updates
- Handles code commits, pull requests, and reviews
- Creates and manages issues for tasks and feedback
- Provides repository state information to agents

### 6. Observability Framework

**Responsibility**: Monitors system performance and traces agent actions.

- Integrates with Langfuse for comprehensive tracing
- Logs agent prompt/response cycles and decisions
- Captures metrics for system performance analysis
- Provides dashboards for monitoring and debugging

## Data Flow & Component Interactions

The following diagram illustrates the high-level data flow through the Clariad system:

```mermaid
graph TD
    User[User] <--> Claude[Claude Desktop LLM API]
    Claude <--> |stdio MCP Protocol| MCP[MCP Interface Layer]

    subgraph "Clariad MCP Server"
        MCP <--> |Tool Invocation| Orchestrator[LangGraph Orchestrator]
        Orchestrator <--> Memory[Semantic Memory System]
        Orchestrator <--> GitHub[GitHub Integration Layer]
        Orchestrator <--> Vision[Vision & Scope Agent]
        Orchestrator <--> Arch[Architecture Agent]
        Orchestrator <--> Task[Task Refinement Agent]
        Orchestrator <--> Dev[Development Agent]
        Orchestrator <--> Review[Review Agent]
        Orchestrator <--> Deploy[Deployment Agent]
        Orchestrator <--> Feedback[Feedback Agent]
        Vision --> Memory
        Arch --> Memory
        Task --> Memory
        Dev --> Memory
        Review --> Memory
        Deploy --> Memory
        Feedback --> Memory
        Vision <--> GitHub
        Arch <--> GitHub
        Task <--> GitHub
        Dev <--> GitHub
        Review <--> GitHub
        Deploy <--> GitHub
        Feedback <--> GitHub
        Orchestrator <--> ObsF[Observability Framework]
    end
```

### Workflow Sequence

1. **User Input**: A user interacts with Claude Desktop via its interface.
2. **Claude Processing**: Claude determines it needs to use a Clariad agent tool and sends a tool invocation request to the MCP Server.
3. **MCP Communication**: The request is sent via standard input/output (stdio) to the Clariad MCP server as defined in the Claude Desktop configuration file.
4. **MCP Handling**: The MCP Interface receives the tool request and forwards it to the Orchestrator.
5. **Agent Selection**: The Orchestrator determines which agent should process the request based on the tool invoked.
6. **Context Gathering**: The selected agent retrieves relevant information from Semantic Memory and/or GitHub.
7. **Processing**: The agent performs its specialized function (design, coding, review, etc.).
8. **Artifact Creation**: The agent generates outputs and stores them in GitHub and Semantic Memory.
9. **Response**: Results are returned to Claude Desktop via the MCP Interface through the stdio channel.
10. **Claude Response**: Claude incorporates the agent's results into its response to the user.
11. **Observability**: All steps are logged and traced through the Observability Framework.

## Technology Stack Choices

The following technology choices form the foundation of the Clariad architecture:

### Core Technologies

| Component | Technology Choice | Rationale |
|-----------|-------------------|-----------|
| Agent Framework | LangGraph + LangChain | Provides robust agent orchestration, state management, and integration capabilities |
| Semantic Memory | PostgreSQL + pgvector | Industry-standard database with vector search capabilities |
| Observability | Langfuse | Specialized for LLM application tracing and monitoring |
| Version Control | GitHub | Required by specifications, industry standard |
| Documentation | Markdown | Required by specifications, readable and widely supported |
| MCP Server | Model Context Protocol SDK | MCP compatibility for Claude Desktop integration |

### Infrastructure Considerations

While specific deployment infrastructure is out of scope, the architecture supports deployment as:

- A containerized application (Docker)
- A serverless function set (AWS Lambda, Google Cloud Functions)
- A traditional web service (FastAPI, Flask, etc.)

## Integration Points

The Clariad ecosystem interfaces with external systems at several key points:

### 1. MCP Client Integration

- **Protocol**: Model-Client Protocol (MCP)
- **Client**: Claude Desktop
- **Capabilities**: Tool registration, streaming responses, multi-turn dialogue
- **Connection Method**: Standard input/output (stdio) through MCP server registration

### 2. GitHub Integration

- **API Access**: GitHub API v4 (GraphQL) and v3 (REST)
- **Permissions Required**:
  - Repository contents (read/write)
  - Issues (read/write)
  - Pull requests (read/write)
  - Workflow (read/write) for CI/CD configuration

### 3. CI/CD System Integration

- **Systems**: GitHub Actions (primary), potentially others
- **Integration Type**: Configuration file generation, status monitoring

## Risks & Mitigations

| Risk | Description | Mitigation |
|------|-------------|------------|
| LLM Limitations | Model hallucinations or knowledge cutoff issues | Implement validation checks, fact-grounding, and human feedback loops |
| Claude Desktop Dependency | Reliance on Claude Desktop's LLM capabilities | Ensure efficient context management, design for graceful degradation |
| GitHub API Rate Limits | Potential throttling with high activity | Implement rate limiting, request batching, and API usage optimization |
| Security Boundaries | Agents need appropriate permissions | Use principle of least privilege, validate operations before execution |
| Maintainability Complexity | Multiple agents may be difficult to maintain | Strong modularity, comprehensive documentation, shared utilities |
| User Experience Consistency | Multiple agents might lead to inconsistent UX | Single MCP interface layer, standardized response formats |

## Architecture Mapping to Requirements

The table below maps key features from the Vision & Scope document to the architectural components that implement them:

| Requirement | Architectural Component |
|-------------|-------------------------|
| Comprehensive Multi-Agent Ecosystem | Specialized Agent Nodes, LangGraph Orchestrator |
| GitHub Integration | GitHub Integration Layer |
| LangGraph Orchestration | LangGraph Orchestrator, Shared State & Memory |
| Claude Desktop Integration | MCP Interface Layer, Claude Desktop MCP Tools |
| Software Engineering Best Practices | Built into agent prompt designs and workflows |
| Observability & Traceability | Observability Framework, Langfuse integration |
| Extensible Infrastructure | Modular design, Semantic Memory System |

## Definition of Done for Architecture

This architecture design is considered "Done" when:

- ✅ All major components are identified and their responsibilities defined
- ✅ Component interactions and data flows are clearly documented
- ✅ Key architectural decisions are documented with ADRs
- ✅ Technical constraints are addressed
- ✅ Requirements from Vision & Scope are mapped to architectural components
- ✅ Risks and mitigations are identified
- ✅ Technology choices are justified
- ✅ Documentation follows the [Documentation Style Guide](/docs/documentation-style-guide.md)
- ✅ All requirements in the [Definition of Done](/docs/process/definition-of-done.md) are satisfied

## Reference Architecture Diagram

The following diagram illustrates a more detailed view of the Clariad system architecture:

```mermaid
flowchart TB
    User((User))

    subgraph "Claude Desktop"
        CD[Claude App]
        LLM[Claude LLM API]
    end

    subgraph "Clariad MCP Server"
        subgraph "MCP Layer"
            MCP[MCP Interface]
            Tools[Tool Registration]
            ResponseHandler[Response Formatter]
        end

        subgraph "Orchestration Layer"
            LG[LangGraph Orchestrator]
            SM[State Manager]
            Router[Request Router]
        end

        subgraph "Agent Layer"
            VA[Vision & Scope Agent]
            AA[Architecture Agent]
            TA[Task Refinement Agent]
            DA[Development Agent]
            RA[Review Agent]
            DPA[Deployment Agent]
            FA[Feedback Agent]
        end

        subgraph "Persistence Layer"
            VDB[(Vector Database)]
            VStore[Vector Store]
        end

        subgraph "Integration Layer"
            GH[GitHub Integration]
            CICD[CI/CD Integration]
        end

        subgraph "Observability Layer"
            LF[Langfuse]
            Logger[Logging System]
            Metrics[Metrics Collection]
        end
    end

    User --> CD
    CD --> LLM
    LLM <-.->|stdio MCP Protocol| MCP
    MCP <--> Tools
    MCP <--> ResponseHandler
    MCP <--> LG
    LG <--> SM
    LG <--> Router
    Router <--> VA
    Router <--> AA
    Router <--> TA
    Router <--> DA
    Router <--> RA
    Router <--> DPA
    Router <--> FA

    VA <--> VStore
    AA <--> VStore
    TA <--> VStore
    DA <--> VStore
    RA <--> VStore
    DPA <--> VStore
    FA <--> VStore

    VStore <--> VDB

    VA <--> GH
    AA <--> GH
    TA <--> GH
    DA <--> GH
    RA <--> GH
    DPA <--> GH
    FA <--> GH

    DPA <--> CICD

    LG --> LF
    VA --> LF
    AA --> LF
    TA --> LF
    DA --> LF
    RA --> LF
    DPA --> LF
    FA --> LF

    LF <--> Logger
    LF <--> Metrics
```

---

**Document Status**: Approved
**Last Updated**: May 17, 2025
**Created By**: Architecture Agent
**Version**: 2.0

See the [architecture/](./architecture/) directory for detailed Architecture Decision Records (ADRs), including the new [ADR-011: Claude Desktop LLM Integration](./architecture/ADR-011-claude-desktop-llm-integration.md).
