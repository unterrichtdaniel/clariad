# Definition of Done

This document outlines the criteria that must be met before any work item (task, user story, feature) is considered complete. Following these standards ensures consistent quality across the Clariad project.

## Development Tasks

A development task is considered "Done" when:

### Code Quality
- [ ] Code follows project style guide and passes all linting checks
- [ ] All new code is covered by automated tests
- [ ] All tests pass locally and in CI
- [ ] Code has been reviewed by at least one other developer
- [ ] Any feedback from code review has been addressed
- [ ] Code has been merged into the target branch

### Documentation
- [ ] Code is properly documented with docstrings and comments as needed
- [ ] API documentation is updated for new or modified functionality
- [ ] **Documentation follows the [Documentation Style Guide](/docs/documentation-style-guide.md)**
- [ ] **New or modified features are documented in the appropriate location**
- [ ] **Documentation uses proper heading structure, file naming conventions, and metadata format**
- [ ] **All internal and external links in documentation are valid and working**
- [ ] **Documentation changes pass the documentation linting checks in CI**

### Technical Requirements
- [ ] Feature meets all requirements specified in the user story or task description
- [ ] Feature is compatible with supported environments and configurations
- [ ] Any required database migrations are included
- [ ] Performance impact has been considered and addressed
- [ ] Security implications have been considered and addressed

### Release Readiness
- [ ] Feature has been deployed to a staging environment
- [ ] Feature has been validated in the staging environment
- [ ] Feature is ready for demonstration to stakeholders
- [ ] Any known issues or limitations are documented
- [ ] Deployment documentation is updated if necessary

## User Stories

A user story is considered "Done" when:

- [ ] All development tasks associated with the user story are "Done"
- [ ] The feature has been demonstrated to and accepted by stakeholders
- [ ] The feature meets all acceptance criteria specified in the user story
- [ ] E2E tests for the feature are implemented and passing
- [ ] Documentation for end users is complete and accurate
- [ ] The feature is deployed to production or ready for production deployment

## Epics/Features

An epic or feature is considered "Done" when:

- [ ] All user stories associated with the epic/feature are "Done"
- [ ] The complete feature set has been demonstrated to and accepted by stakeholders
- [ ] All documentation (architecture, user, developer) is complete and published
- [ ] All metrics and monitoring for the feature are in place
- [ ] A retrospective on the epic/feature development has been conducted

## Documentation-Specific Definition of Done

For documentation-specific tasks, the following additional criteria apply:

- [ ] Document follows all guidelines in the Documentation Style Guide
- [ ] File uses the correct kebab-case naming convention
- [ ] Document has exactly one H1 heading as the title
- [ ] Headings follow hierarchical structure (H1 > H2 > H3) without skipping levels
- [ ] All internal links are verified and working
- [ ] All external links are verified and working
- [ ] Document includes proper metadata (status, date, author, version)
- [ ] Mermaid diagrams (if present) use consistent styling
- [ ] Document passes all linting checks in CI
- [ ] Document has been reviewed by at least one other team member
- [ ] All feedback from documentation review has been addressed

---

*Document Status: Active*
*Last Updated: May 18, 2025*
*Created By: Development Team*
*Version: 1.1*
