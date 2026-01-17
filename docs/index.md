# BMAD Quality Kit Documentation

Welcome to the BMAD Quality Kit documentation. This kit provides a comprehensive system for ensuring test quality and enforcing invariants in AI-assisted development.

## Quick Navigation

### Getting Started
- [Getting Started Guide](getting-started.md) - Install and configure the kit

### Testing
- [Testing Philosophy](testing/philosophy.md) - Why waterdichte tests matter
- [Test Pyramid](testing/test-pyramid.md) - Unit vs Integration vs E2E
- [When to Use Playwright](testing/when-playwright.md) - Decision guide
- [Writing Good Tests](testing/writing-good-tests.md) - Best practices

### Invariants
- [What Are Invariants](invariants/what-are-invariants.md) - Core concept
- [How to Discover](invariants/how-to-discover.md) - Discovery process
- [How to Test](invariants/how-to-test.md) - NEVER-test patterns

### BMAD Workflow
- [BMAD Overview](bmad/overview.md) - Story-driven development
- [Story Format](bmad/story-format.md) - AC and Task structure

### CTO Review
- [CTO Review Checklist](cto-review/checklist.md) - Quality gates

## Core Concepts

### The 4-Layer System

```
LAAG 1: SPECIFICATIE
├── test-requirements.yaml    # Welke tests per path
└── invariants.md             # Wat mag NOOIT

LAAG 2: AI GUIDANCE
├── /test-guard               # Test enforcement skill
└── /invariant-discovery      # Discovery skill

LAAG 3: ENFORCEMENT
├── test-gate.ps1             # CLI test checker
└── invariant-check.ps1       # CLI invariant checker

LAAG 4: CI/CD
└── GitHub/GitLab workflows
```

### Skills Overview

| Skill | Purpose | Invocation |
|-------|---------|------------|
| `/test-guard` | Validate tests exist | Before "done" |
| `/invariant-discovery` | Discover invariants | Project setup |
| `/bmad-autopilot` | BMAD workflow | Feature development |
| `/cto-guard` | CTO validation | Automated |
| `/ralph-loop` | Story iteration | After BMAD |

### Tools Overview

| Tool | Purpose | Exit Code |
|------|---------|-----------|
| `test-gate.ps1` | Check required tests | 0=pass, 1=fail |
| `invariant-check.ps1` | Check NEVER-tests | 0=pass, 1=fail |
| `preflight.ps1` | Story validation | 0=pass, 2=fail |

## Installation

```powershell
pwsh INSTALL.ps1 -TargetProject /path/to/project
```

## Version

Quality Kit v1.0.0 - 2026-01-17
