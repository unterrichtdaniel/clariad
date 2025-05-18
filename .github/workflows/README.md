# Documentation Linting

This directory contains GitHub Actions workflows for ensuring documentation quality in the Clariad project.

## Overview

The `documentation-lint.yml` workflow runs automatically when:
- Any Markdown file is pushed to main/master branches
- Any Markdown file is changed in a pull request to main/master
- The workflow is manually triggered

## What It Checks

The documentation linting process verifies:

1. **Markdown Standards**: Basic markdown syntax and style using markdownlint
2. **Heading Structure**:
   - Each file has exactly one H1 heading
   - Headings follow proper hierarchy (no skipping levels)
3. **File Naming Conventions**:
   - Files use kebab-case (except ADRs and User Stories)
   - No uppercase letters or underscores in filenames
4. **Required Metadata**:
   - Each file includes Document Status, Last Updated, and Version
5. **Link Validity**:
   - Internal links point to existing files
   - External links are reachable
6. **Mermaid Diagrams**:
   - Diagrams use consistent arrow styles
7. **Spelling and Grammar**:
   - Common spelling mistakes are caught
   - Project-specific terms are recognized

## Configuration Files

- `.markdownlint.json`: Rules for markdown style
- `markdown-link-check-config.json`: Settings for link checking
- `cspell.json`: Dictionary and rules for spell checking

## Manual Running

You can manually trigger the workflow from the "Actions" tab in GitHub by selecting "Documentation Linting" and clicking "Run workflow".

## Local Testing

To run these checks locally before committing:

1. Install the required tools:
   ```bash
   npm install -g markdownlint-cli markdown-link-check cspell
   ```

2. Run markdownlint:
   ```bash
   markdownlint 'docs/**/*.md'
   ```

3. Check links:
   ```bash
   find docs -name "*.md" -print0 | xargs -0 -n1 markdown-link-check
   ```

4. Check spelling:
   ```bash
   cspell "docs/**/*.md"
   ```

## See Also

- [Documentation Style Guide](/docs/documentation-style-guide.md)
- [Definition of Done](/docs/process/definition-of-done.md)

---

*Document Status: Active*
*Last Updated: May 18, 2025*
*Created By: Documentation Team*
*Version: 1.0*
