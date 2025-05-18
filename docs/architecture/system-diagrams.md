# Clariad System Architecture Diagrams

This document contains the high-level architectural diagrams for the Clariad AI Agent Ecosystem.

## System Component Overview

The following diagram illustrates the major components of the Clariad system and their relationships:

```mermaid
graph TB
    User((User))

    subgraph "Claude Desktop"
        Claude[Claude App]
        ClaudeLLM[Claude LLM]
        Claude <--> ClaudeLLM
    end

    subgraph "Clariad System"
        MCP[MCP Interface Layer]

        subgraph "Core System"
            Orchestrator[LangGraph Orchestrator]
            Memory[(Semantic Memory)]
        end

        subgraph "Agent Layer"
            Vision[Vision & Scope Agent]
            Architecture[Architecture Agent]
            Task[Task Refinement Agent]
            Development[Development Agent]
            Review[Review Agent]
            Deployment[Deployment Agent]
            Feedback[Feedback Agent]
        end

        subgraph "Integration Layer"
            GitHub[GitHub Integration]
            Langfuse[Observability]
        end
    end

    subgraph "External Systems"
        GitHubRepo[(GitHub Repository)]
        CI[CI/CD Systems]
    end

    User --> Claude
    Claude <--> MCP

    MCP <--> Orchestrator

    Orchestrator --> Vision
    Orchestrator --> Architecture
    Orchestrator --> Task
    Orchestrator --> Development
    Orchestrator --> Review
    Orchestrator --> Deployment
    Orchestrator --> Feedback

    Orchestrator <--> Memory

    Vision <--> GitHub
    Architecture <--> GitHub
    Task <--> GitHub
    Development <--> GitHub
    Review <--> GitHub
    Deployment <--> GitHub
    Feedback <--> GitHub

    GitHub <--> GitHubRepo
    Deployment <--> CI

    Orchestrator --> Langfuse
```

## Agent Workflow Sequence

The following diagram illustrates the workflow sequence for the Clariad agent system:

```mermaid
sequenceDiagram
    participant User as User
    participant Claude as Claude Desktop
    participant MCP as MCP Interface
    participant Orch as Orchestrator
    participant Vision as Vision & Scope
    participant Arch as Architecture
    participant Task as Task Refinement
    participant Dev as Development
    participant Review as Review
    participant Deploy as Deployment
    participant Feedback as Feedback
    participant GitHub as GitHub
    participant Memory as Semantic Memory

    User->>Claude: Request project creation
    Claude->>MCP: Invoke Clariad tool
    MCP->>Orch: Forward tool request

    Orch->>Vision: Initiate Vision & Scope
    Vision->>Memory: Retrieve related context
    Vision->>GitHub: Create vision-and-scope.md
    Vision->>Memory: Store outputs
    Vision->>Orch: Complete

    Orch->>MCP: Return initial results
    MCP->>Claude: Provide tool response
    Claude->>User: Show vision results

    Claude->>MCP: Invoke architecture tool
    MCP->>Orch: Forward tool request

    Orch->>Arch: Initiate Architecture
    Arch->>Memory: Retrieve Vision & Scope
    Arch->>GitHub: Create Architecture.md
    Arch->>GitHub: Create ADRs
    Arch->>Memory: Store outputs
    Arch->>Orch: Complete

    Orch->>MCP: Return architecture results
    MCP->>Claude: Provide tool response
    Claude->>User: Show architecture results

    Claude->>MCP: Invoke task refinement tool
    MCP->>Orch: Forward tool request

    Orch->>Task: Initiate Task Refinement
    Task->>Memory: Retrieve Vision & Architecture
    Task->>GitHub: Create user-stories.md
    Task->>GitHub: Create GitHub issues
    Task->>Memory: Store outputs
    Task->>Orch: Complete

    Orch->>MCP: Return task results
    MCP->>Claude: Provide tool response
    Claude->>User: Show task results

    loop For each user story
        Claude->>MCP: Invoke development tool
        MCP->>Orch: Forward tool request
        Orch->>Dev: Initiate Development
        Dev->>Memory: Retrieve story & architecture
        Dev->>GitHub: Create tests
        Dev->>GitHub: Implement code
        Dev->>Memory: Store outputs
        Dev->>Orch: Complete
        Orch->>MCP: Return development results
        MCP->>Claude: Provide tool response
        Claude->>User: Show development progress
    end

    Claude->>MCP: Invoke review tool
    MCP->>Orch: Forward tool request

    Orch->>Review: Initiate Review
    Review->>GitHub: Get PR/commits
    Review->>Memory: Retrieve requirements
    Review->>GitHub: Post review comments
    Review->>Memory: Store outputs
    Review->>Orch: Complete (approve/request changes)

    alt Changes Requested
        Orch->>MCP: Return review issues
        MCP->>Claude: Provide tool response
        Claude->>User: Show needed changes
        User->>Claude: Approve fixes
        Claude->>MCP: Invoke fix tool
        MCP->>Orch: Forward tool request
        Orch->>Dev: Fix issues
        Dev->>GitHub: Update code
        Dev->>Orch: Complete fixes
        Orch->>Review: Re-review
        Review->>Orch: Approve changes
    end

    Orch->>MCP: Return review results
    MCP->>Claude: Provide tool response
    Claude->>User: Show review results

    Claude->>MCP: Invoke deployment tool
    MCP->>Orch: Forward tool request

    Orch->>Deploy: Initiate Deployment
    Deploy->>GitHub: Configure CI/CD
    Deploy->>GitHub: Tag release
    Deploy->>Memory: Store outputs
    Deploy->>Orch: Complete

    Orch->>MCP: Return deployment results
    MCP->>Claude: Provide tool response
    Claude->>User: Show deployment results

    Claude->>MCP: Invoke feedback tool
    MCP->>Orch: Forward tool request

    Orch->>Feedback: Initiate Feedback
    Feedback->>GitHub: Analyze repo state
    Feedback->>Memory: Retrieve initial requirements
    Feedback->>GitHub: Create Retrospective.md
    Feedback->>GitHub: Create follow-up issues
    Feedback->>Memory: Store outputs
    Feedback->>Orch: Complete

    Orch->>MCP: Return feedback results
    MCP->>Claude: Provide tool response
    Claude->>User: Present complete project summary
```

## LangGraph State Machine

The following diagram illustrates the LangGraph state machine for the Clariad system:

```mermaid
stateDiagram-v2
    [*] --> Initialization
    Initialization --> VisionScope

    VisionScope --> Architecture
    Architecture --> TaskRefinement

    TaskRefinement --> Development
    Development --> Review

    Review --> Development: Changes Needed
    Review --> Deployment: Approved

    Deployment --> Feedback
    Feedback --> [*]: Complete Cycle

    Feedback --> VisionScope: New Iteration
```

## Data Model

The following diagram illustrates the simplified semantic memory data model:

```mermaid
erDiagram
    DOCUMENT {
        string id
        string type
        string content
        vector embedding
        timestamp created_at
        timestamp updated_at
        string agent_source
    }

    PROJECT {
        string id
        string name
        string repository_url
        timestamp created_at
        string status
    }

    USER_STORY {
        string id
        string title
        string description
        string acceptance_criteria
        string status
        int priority
    }

    AGENT_RUN {
        string id
        string agent_type
        timestamp started_at
        timestamp completed_at
        string status
        json metadata
    }

    PROJECT ||--o{ DOCUMENT : contains
    PROJECT ||--o{ USER_STORY : contains
    PROJECT ||--o{ AGENT_RUN : has
    DOCUMENT ||--o{ DOCUMENT : references
    USER_STORY ||--o{ DOCUMENT : produces
    AGENT_RUN ||--o{ DOCUMENT : generates
```
