# Development Workflow Guide

This guide explains the development workflow when working with the Clariad AI Agent Ecosystem.

## Overview

Clariad uses a structured development workflow based on Agile, BDD, and TDD principles. The workflow is orchestrated by specialized AI agents that guide the process from initial vision to deployment and feedback.

## Development Lifecycle

### 1. Vision and Scope

The development lifecycle begins with establishing a clear vision and scope for the project or feature:

1. Define project goals and objectives
2. Identify stakeholders and users
3. Determine key features and capabilities
4. Establish constraints and assumptions
5. Define success metrics

The Vision & Scope Agent assists in this process by generating a comprehensive Vision & Scope document.

### 2. Architecture Design

Once the vision and scope are established, the next step is to design the system architecture:

1. Identify system components and their responsibilities
2. Define component interactions and data flows
3. Document architectural decisions using ADRs
4. Address technical constraints and requirements

The Architecture Agent assists by generating architecture documentation and ADRs.

### 3. Task Refinement

With architecture in place, features are broken down into well-defined user stories:

1. Create user stories using the format: "As a [role], I want [goal] so that [benefit]"
2. Define acceptance criteria using Gherkin syntax (Given/When/Then)
3. Ensure stories meet INVEST criteria
4. Prioritize stories in the backlog

The Task Refinement Agent helps create user stories with clear acceptance criteria.

### 4. Development

Development follows Test-Driven Development (TDD) principles:

1. Write tests first based on acceptance criteria
2. Implement code to pass the tests
3. Refactor for clean, maintainable code
4. Document code and implementation details

The Development Agent assists by implementing code using TDD principles.

### 5. Review

All code undergoes thorough review:

1. Verify code meets acceptance criteria
2. Check adherence to coding standards
3. Analyze test coverage
4. Review for security, performance, and maintainability

The Review Agent helps by verifying code quality and correctness.

### 6. Deployment

Once code is reviewed and approved, it's prepared for deployment:

1. Configure CI/CD pipeline for the feature
2. Prepare deployment documentation
3. Create release notes
4. Ensure monitoring and observability

The Deployment Agent assists by managing CI/CD configuration and deployment readiness.

### 7. Feedback

After deployment, feedback is collected and analyzed:

1. Gather user feedback
2. Analyze system metrics and performance
3. Identify areas for improvement
4. Feed insights back into the development process

The Feedback Agent helps by generating retrospective reports and identifying improvements.

## Working with Clariad Agents

### Interactive Mode

In interactive mode, you collaborate with Clariad agents step-by-step:

1. Start a conversation with Claude Desktop
2. Describe your project or feature
3. Claude will invoke the appropriate Clariad agents as needed
4. Review and provide feedback on each agent's output
5. Guide the process with additional input and direction

### Autonomous Mode

In autonomous mode, Clariad handles the entire workflow with minimal intervention:

1. Provide a project description or requirements
2. Request autonomous mode
3. Clariad proceeds through all stages with minimal input
4. Review outputs at key checkpoints

## Best Practices

1. **Provide Clear Requirements**: The more clear and detailed your initial requirements, the better results you'll get.

2. **Review Agent Outputs**: Always review and provide feedback on agent outputs to improve results.

3. **Maintain Consistency**: Use consistent terminology and follow the established workflow.

4. **Document Decisions**: Ensure all significant decisions are documented, including the reasoning behind them.

5. **Follow the Definition of Done**: Ensure all work meets the criteria in the [Definition of Done](/docs/contributing/definition-of-done.md).

## Troubleshooting

If you encounter issues with the development workflow:

1. Check that the appropriate Clariad agents are available in Claude Desktop
2. Verify that GitHub integration is configured correctly
3. Ensure you have the necessary permissions for GitHub operations
4. See the [Troubleshooting Guide](/docs/getting-started/troubleshooting.md) for more assistance

---

*Document Status: Active*
*Last Updated: May 19, 2025*
*Created By: Development Team*
*Version: 1.0*
