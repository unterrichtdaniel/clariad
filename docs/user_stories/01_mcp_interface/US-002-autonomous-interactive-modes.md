# US-002: Autonomous and Interactive Modes

**As a** user,  
**I want** to choose between autonomous and interactive operation modes in Claude Desktop  
**So that** I can either let the system work independently or collaborate step by step.

## Acceptance Criteria

### Scenario: Autonomous Mode Selection
- Given I am using Claude Desktop with Clariad configured
- When I request "Run Clariad in autonomous mode" with a project specification
- Then Claude should invoke Clariad's autonomous workflow tool
- And the system should execute the full workflow from Vision to Feedback without further prompting
- And only prompt me at defined checkpoints or when blocking issues arise

### Scenario: Interactive Mode Selection
- Given I am using Claude Desktop with Clariad configured
- When I make a specific phase request like "Design the architecture for this project"
- Then Claude should invoke the appropriate Clariad tool for that specific phase
- And the system should execute only the requested action
- And wait for my input before proceeding to subsequent phases

### Scenario: Checkpoint Approval
- Given Clariad is running in autonomous mode
- When it reaches a defined checkpoint (e.g., after Architecture design)
- Then it should pause execution
- And return control to Claude with a request for my approval
- And wait for my response before continuing

### Scenario: Mode Switching
- Given I am in the middle of a development workflow with Clariad
- When I request to change operation mode
- Then Claude should invoke Clariad's mode-switching tool
- And the system should confirm the change
- And switch modes while maintaining the current context and state

## Definition of Ready Checklist

- [x] Autonomous workflow sequence is defined
- [x] Interactive operation commands are documented
- [x] Checkpoint locations are clearly specified
- [x] State persistence requirements are defined
- [x] Mode transition handling is described

## Technical Notes

This user story builds on US-001 (MCP Server Implementation) and requires coordination with the LangGraph orchestrator to manage different execution modes. Clariad must register both autonomous and interactive tool variants with Claude Desktop and be able to persist state between tool invocations. The system must handle complex workflows while presenting them as simple tool actions to Claude Desktop.

## Related Architecture Elements

- ADR-004: MCP Protocol Integration
- ADR-011: Claude Desktop LLM Integration
- LangGraph Orchestrator component
- MCP Interface Layer in the system architecture
- Semantic Memory System for state persistence

---

*Priority: 3-Enhanced Functionality*  
*Story Points: 5*  
*Created: May 17, 2025*