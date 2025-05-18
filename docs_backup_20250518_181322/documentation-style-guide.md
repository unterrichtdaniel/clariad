# Clariad Documentation Style Guide

## Overview

This style guide establishes standards for all Clariad documentation to ensure consistency, clarity, and professionalism across the documentation set.

## Document Structure

### File Organization

- All documentation should be stored in the `docs/` directory
- Use subdirectories for organizing related documents:
  - `docs/architecture/` - Architecture documentation and ADRs
  - `docs/user_stories/` - User stories and requirements
  - `docs/ci_cd/` - CI/CD pipeline documentation
  - `docs/dev_setup/` - Development environment setup
  - `docs/references/` - Reference documentation

### File Naming Conventions

- Use kebab-case (lowercase with hyphens) for all documentation files
  - Correct: `getting-started.md`, `vision-and-scope.md`
  - Incorrect: `Getting_Started.md`, `VisionAndScope.md`
- Special document types should follow these patterns:
  - Architecture Decision Records: `adr-###-short-title.md` (e.g., `adr-001-multi-agent-architecture.md`)
  - User Stories: `us-###-short-title.md` (e.g., `us-001-mcp-server-implementation.md`)

### Heading Structure

- Each document must have exactly ONE H1 heading as its title
- Headings must follow hierarchical structure without skipping levels:
  ```
  # Document Title (H1)
    ## Major Section (H2)
      ### Subsection (H3)
        #### Sub-subsection (H4)
  ```
- Do not use more than one H1 in a single document
- Keep heading text concise but descriptive

### Heading Capitalization

- Use Title Case for all headings (capitalize each word except articles, prepositions, and conjunctions)
  - Correct: "Getting Started with Clariad"
  - Incorrect: "Getting started with clariad"

## Document Metadata

Every document should include the following metadata at the bottom of the file:

```markdown
---

*Document Status: [Draft|Active|Archived]*
*Last Updated: YYYY-MM-DD*
*Created By: [Author or Team Name]*
*Version: [X.Y]*
```

## Writing Style

### Voice and Tone

- Use a formal but accessible tone
- Write in third person for technical documentation and second person ("you") for guides and tutorials
- Be direct and concise
- Present information objectively

### Grammar and Spelling

- Use American English spelling consistently
- Write in present tense when possible
- Use active voice rather than passive voice
  - Preferred: "The system stores data in PostgreSQL"
  - Avoid: "Data is stored in PostgreSQL by the system"
- Avoid contractions in formal technical documentation

### Terminology

Always use consistent terminology throughout the documentation:

| Preferred Term | Avoid |
|----------------|-------|
| Task | Issue, Ticket (except when referring to GitHub Issues specifically) |
| Agent | Bot |
| Model-Client Protocol (MCP) | MCP (without first spelling it out) |
| Claude Desktop | Claude client, Claude app |
| Orchestrator | Coordinator, Manager |

Always spell out acronyms on first use in each document, followed by the acronym in parentheses.

### Punctuation and Formatting

- Lists:
  - Use bullet points for unordered lists
  - Use numbers for sequential steps
  - Be consistent with terminal punctuation:
    - For complete sentences, include periods
    - For phrases or fragments, omit periods
- Emphasis:
  - Use **bold** for emphasis or UI elements
  - Use *italic* for introducing new terms
  - Use `code font` for code, commands, or file names
- Numbers:
  - Spell out numbers zero through nine
  - Use numerals for 10 and above
  - Always use numerals for versions, measurements, and technical specifications

## Code and Technical Content

### Code Blocks

- Always specify the language for syntax highlighting:
  ```markdown
  ```python
  def example():
      return "Hello, world!"
  ```
  ```
- Keep lines under 80 characters when possible
- Include comments for complex code

### Command Line Examples

- Precede commands with a prompt symbol:
  ```bash
  # Install dependencies
  $ poetry install
  ```
- Include expected output when helpful
- Use placeholders in italic and descriptive brackets for variable content:
  ```bash
  $ cd /path/to/*your-repository*
  ```

### Mermaid Diagrams

- Specify "mermaid" as the language for diagram code blocks
- Use consistent arrow styles within each diagram:
  - Flowcharts: `-->` for standard connections, `==>` for emphasized ones
  - Sequence diagrams: `->>` for requests, `-->>` for responses
- Add text labels to diagram elements to improve clarity
- Keep diagrams focused on a single concept
- Use consistent node shapes and styles across related diagrams

## Links and References

### Internal Links

- Use relative paths for internal links to other documents:
  ```markdown
  See the [Architecture document](../architecture/architecture.md)
  ```
- For section links within the same document, use anchor links based on heading text:
  ```markdown
  See the [Installation section](#installation)
  ```
- Ensure anchor text is descriptive and relevant

### External Links

- Provide context for external links:
  ```markdown
  Read the [Claude Desktop documentation](https://docs.anthropic.com/claude/docs/claude-desktop)
  ```
- Verify external links regularly
- Consider including the domain in parentheses for less-known links:
  ```markdown
  See the [Anthropic blog post](https://www.anthropic.com/blog/claude-3) (anthropic.com)
  ```

## Images and Visual Elements

- Include alt text for all images:
  ```markdown
  ![Architecture diagram showing system components](images/architecture.png)
  ```
- Store images in an `images/` subdirectory
- Use PNG format for diagrams and screenshots
- Keep image file sizes reasonable (compress when necessary)
- Caption images when additional context is helpful

## Accessibility Considerations

- Use descriptive link text (avoid "click here" or "read more")
- Provide text alternatives for visual content
- Use sufficient color contrast
- Structure content with proper headings
- Use tables for tabular data, not for layout

## Document Review Process

1. Self-review using this style guide
2. Technical accuracy review
3. Editorial review for style consistency
4. Final approval by documentation owner

By following these guidelines, we will create documentation that is consistent, professional, and user-friendly.
