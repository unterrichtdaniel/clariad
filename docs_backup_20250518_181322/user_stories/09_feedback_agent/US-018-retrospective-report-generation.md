# US-018: Retrospective Report Generation

**As a** project manager,
**I want** the Feedback agent to generate comprehensive retrospective reports
**So that** the team can learn from each development cycle and continuously improve.

## Acceptance Criteria

### Scenario: Process Analysis
- Given the completion of a development cycle
- When the Feedback agent analyzes the process
- Then it should identify what went well and what needs improvement
- And organize findings into clear, actionable categories

### Scenario: Architectural Drift Detection
- Given the initial architecture and the implemented codebase
- When the Feedback agent compares them
- Then it should identify any architectural drift
- And provide recommendations for alignment or architecture updates

### Scenario: Technical Debt Identification
- Given the codebase and development history
- When the Feedback agent analyzes code quality
- Then it should identify accumulating technical debt
- And prioritize areas requiring refactoring

### Scenario: Action Item Creation
- Given identified improvement areas
- When the Feedback agent finalizes the retrospective
- Then it should create clear, actionable improvement items
- And create corresponding GitHub issues for tracking

### Scenario: Metric Analysis
- Given project success metrics from the Vision document
- When the Feedback agent evaluates progress
- Then it should assess current status against defined metrics
- And provide insights on meeting project goals

## Definition of Ready Checklist

- [x] Retrospective format is defined
- [x] Architectural comparison approach is documented
- [x] Technical debt identification criteria are specified
- [x] Action item format is established
- [x] Metric evaluation guidance is available

## Technical Notes

This user story follows the CI/CD Pipeline Configuration (US-016) in the workflow and represents the final stage in the development cycle. The Feedback agent must analyze the entire project history, compare the initial plans with the final implementation, and generate a comprehensive retrospective that identifies lessons learned and areas for improvement. This retrospective becomes input for the next development cycle.

## Related Architecture Elements

- Feedback Agent component in the system architecture
- Semantic Memory System for retrieving project history
- GitHub Integration Layer for issue creation
- Feedback loop to Vision and Architecture stages

---

*Priority: 2-Core Agent Implementation*
*Story Points: 8*
*Created: May 17, 2025*
