# US-002: Autonomous and Interactive Modes

**As a** user,  
**I want** to choose between autonomous and interactive operation modes  
**So that** I can either let the system work independently or collaborate step by step.

## Acceptance Criteria

### Scenario: Autonomous Mode Selection
- Given I am connected to the Clariad system
- When I request "Run in autonomous mode" with a project specification
- Then the system should execute the full workflow from Vision to Feedback
- And only prompt me at defined checkpoints or when blocking issues arise

### Scenario: Interactive Mode Selection
- Given I am connected to the Clariad system
- When I request "Run in interactive mode" or make a specific phase request
- Then the system should execute only the requested actions
- And wait for my input before proceeding to subsequent phases

### Scenario: Checkpoint Approval
- Given the system is running in autonomous mode
- When it reaches a defined checkpoint (e.g., after Architecture design)
- Then it should pause execution
- And request my approval before continuing

### Scenario: Mode Switching
- Given I am in the middle of a development workflow
- When I request to change operation mode
- Then the system should confirm the change
- And switch modes while maintaining the current context and state

## Definition of Ready Checklist

- [x] Autonomous workflow sequence is defined
- [x] Interactive operation commands are documented
- [x] Checkpoint locations are clearly specified
- [x] State persistence requirements are defined
- [x] Mode transition handling is described

## Technical Notes

This user story builds on US-001 (MCP Server Implementation) and requires coordination with the LangGraph orchestrator to manage different execution modes. The system must be able to persist state during pauses in execution and handle user interventions at key points in the workflow.

## Related Architecture Elements

- LangGraph Orchestrator component
- MCP Interface Layer in the system architecture
- Semantic Memory System for state persistence

---

*Priority: 3-Enhanced Functionality*  
*Story Points: 5*  
*Created: May 17, 2025*