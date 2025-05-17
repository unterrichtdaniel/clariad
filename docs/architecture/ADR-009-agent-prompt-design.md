# ADR-009: Agent Prompt Design Strategy

## Status

Accepted

## Context

The effectiveness of the Clariad AI Agent Ecosystem depends heavily on the quality and structure of prompts used for each specialized agent. Well-designed prompts ensure agents fulfill their specific roles, adhere to best practices, and produce consistent, high-quality outputs.

## Decision

We will implement a standardized prompt design strategy for all agents that includes role definition, structured guidance, engineering best practices, and few-shot examples. Prompts will be version-controlled and systematically improved based on performance data.

## Alternatives Considered

1. **Ad-hoc Prompt Creation**: Crafting prompts without standardization as needed.
   - Pros: Flexibility, less upfront effort.
   - Cons: Inconsistency, poor maintainability, quality variations.

2. **Single Universal Prompt**: Using a single comprehensive prompt with conditionals.
   - Pros: Centralized management, consistency.
   - Cons: Complexity, context window limitations, role confusion.

3. **Fully Automated Prompt Generation**: Generating prompts dynamically based on parameters.
   - Pros: Adaptability, customization potential.
   - Cons: Unpredictable quality, complexity, harder to version control.

## Decision Drivers

1. **Agent Performance**: Maximizing the effectiveness of each agent in its role.
2. **Consistency**: Ensuring reliable outputs across system usage.
3. **Maintainability**: Ability to update and improve prompts over time.
4. **Best Practices**: Incorporation of software engineering standards.
5. **Documentation**: Self-documenting nature of well-structured prompts.

## Consequences

### Positive

- Improved agent performance through optimized prompts
- Consistent outputs across similar requests
- Clear expectations for each agent's responsibilities
- Easier maintenance through standardized structure
- Better incorporation of software development best practices
- Ability to version and evolve prompts based on performance data

### Negative

- Initial investment in prompt engineering and design
- Risk of over-engineering prompts
- Potential context window limitations for comprehensive prompts
- Need for regular updates as LLM capabilities evolve
- Challenge of balancing specificity with flexibility

## Implementation Notes

### Prompt Structure

Each agent prompt will follow a standardized structure:

1. **Role Definition**: Clear statement of the agent's role and responsibilities.
2. **Goal Statement**: Explicit objective for the agent to accomplish.
3. **Context Incorporation**: Instructions for using available context and history.
4. **Output Format**: Specification of expected output structure and format.
5. **Process Guidance**: Step-by-step process the agent should follow.
6. **Best Practices**: Domain-specific best practices and standards.
7. **Quality Criteria**: Explicit quality checks the agent should perform.
8. **Constraints**: Any limitations or boundaries for the agent's work.
9. **Few-Shot Examples**: Concrete examples of expected inputs and outputs.

### Specialized Elements by Agent Type

Each agent type will have specialized prompt elements:

**Vision & Scope Agent**:
- INVEST criteria adaptation for features
- Definition of Ready (DoR) checklists
- Stakeholder analysis guidance

**Architecture Agent**:
- ADR format specifications
- Architecture principles (SOLID, etc.)
- Component relationship mapping guidance
- Mermaid diagram format instructions

**Task Refinement Agent**:
- User story format requirements
- BDD scenario structure (Given/When/Then)
- INVEST criteria for stories
- Prioritization guidelines

**Development Agent**:
- TDD workflow instructions
- Language-specific best practices
- Documentation requirements
- Definition of Done (DoD) checklist

**Review Agent**:
- Code review criteria
- Quality assurance checklists
- Constructive feedback guidelines
- Security review elements

**Deployment Agent**:
- CI/CD configuration standards
- Environment setup guidance
- Infrastructure-as-code principles
- Testing verification requirements

**Feedback Agent**:
- Retrospective format
- Architecture drift analysis methods
- Improvement categorization guidelines
- Action item creation format

### Prompt Management

- All prompts will be stored in version control
- Prompt templates will use variable substitution for dynamic elements
- Performance metrics from Langfuse will inform prompt improvements
- A/B testing framework for evaluating prompt modifications
- Regular review cycle for all agent prompts

## Related Decisions

- ADR-001: Multi-Agent System Architecture
- ADR-006: Observability with Langfuse
- ADR-010: Markdown as Documentation Format