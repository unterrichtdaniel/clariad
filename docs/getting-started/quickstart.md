# Quick Start Guide

This guide will help you quickly get started with using the Clariad AI Agent Ecosystem after installation.

## Using Clariad

Once Clariad is configured with Claude Desktop, you can access its capabilities by asking Claude to perform software development tasks. The MCP tool icon should appear in the Claude Desktop interface when Clariad's tools are available.

## Example Usage Patterns

### Project Initialization

To start a new project with Clariad, you can say:

```
I want to create a new web application for task management. Can you help me design this project using Clariad?
```

Claude will invoke the Vision & Scope Agent to help define the project's goals and requirements.

### Architecture Design

To design the architecture for your project:

```
Design the architecture for a REST API service that manages user authentication and task tracking.
```

Claude will use the Architecture Agent to create architecture documentation and diagrams.

### Task Refinement

To break down features into user stories:

```
Break down the user authentication feature into specific user stories with acceptance criteria.
```

The Task Refinement Agent will generate well-structured user stories with Gherkin-style acceptance criteria.

### Development

To implement a specific feature:

```
Implement the user registration functionality based on the acceptance criteria we defined.
```

The Development Agent will use Test-Driven Development to create tests and implementation.

### Code Review

To review implemented code:

```
Review the code implementation for the user registration feature and suggest improvements.
```

The Review Agent will analyze the code for quality, adherence to requirements, and suggest improvements.

## Operation Modes

Clariad supports two primary operation modes:

### 1. Interactive Mode

In this mode, you guide the process and make decisions at each phase. Clariad will wait for your input before proceeding to the next step.

This is the default mode and is ideal for:
- Learning how Clariad works
- Projects where you want fine-grained control
- Situations where you want to provide feedback at each stage

### 2. Autonomous Mode

In autonomous mode, Clariad automatically steps through the entire development workflow with minimal intervention, pausing only at defined checkpoints.

To select autonomous mode:
```
Please run Clariad in autonomous mode to develop the complete task management application based on our requirements.
```

This mode is ideal for:
- Experienced users who already understand the workflow
- Projects with well-defined requirements
- Rapid prototyping and development

## Tips for Best Results

1. **Be Specific**: Provide clear, detailed requirements when starting a project
2. **Use Consistent Terminology**: Maintain consistent terminology across your interactions
3. **Review Each Stage**: Take time to review and understand the outputs at each stage
4. **Provide Feedback**: Give feedback to help Clariad better understand your needs
5. **Start Small**: Begin with smaller features before tackling complex ones

## Next Steps

- Explore the [Architecture Documentation](/docs/architecture/README.md) to understand how Clariad's components work together
- Review the [User Stories](/docs/user-stories/README.md) for detailed functionality descriptions
- Learn about [GitHub Integration](/docs/guides/github-integration.md) to understand how Clariad works with GitHub

If you encounter any issues, refer to the [Troubleshooting Guide](troubleshooting.md).

---

*Document Status: Active*
*Last Updated: May 18, 2025*
*Created By: Documentation Team*
*Version: 1.0*
