# BMAD Overview

## What is BMAD?

BMAD (Behavior-Mapped Acceptance-Driven Development) is a story-driven development workflow that ensures:

1. Clear requirements before coding
2. CTO validation at key checkpoints
3. Complete test coverage
4. Traceable acceptance criteria

## The Workflow

```
INPUT.md (Requirements)
       │
       ▼
CTO GUARD #1 (Pre-generation)
       │
       ▼
RUN1: Generate Stories
       │
       ▼
CTO GUARD #2 (Post-generation)
       │
       ▼
Preflight Check
       │
       ▼
RUN2: Execute Stories (Ralph Loop)
       │
       ├─► Story 1 → Gate A → CTO Guard #3
       ├─► Story 2 → Gate A → CTO Guard #3
       └─► Story N → Gate A → CTO Guard #3
       │
       ▼
DONE
```

## Key Concepts

### Stories

Discrete units of work with:
- Context and description
- Acceptance Criteria (AC)
- Tasks and subtasks
- Test requirements
- Relevant invariants

### Acceptance Criteria (AC)

Each AC has:
- Given/When/Then format
- CTO Rule traceability
- Verification command
- Expected output

### CTO Guard

Automated validation against CTO rules:
- Pre-generation: Validate input
- Post-generation: Validate stories
- Post-execution: Validate code

### Gate A

Quality gate before completion:
1. Lint (ruff)
2. Tests (pytest)
3. Test requirements (test-gate.ps1)
4. Invariant coverage (invariant-check.ps1)

## Invocation

### Full Workflow

```bash
/bmad-autopilot
```

Runs complete workflow from input to execution.

### Generate Only

```bash
/bmad-autopilot --generate-only
```

Generates stories without executing them.

### Execute Stories

```bash
/ralph-loop
```

Iterates through stories in BACKLOG.md.

## Files

| File | Purpose |
|------|---------|
| `INPUT.md` | Requirements input |
| `stories/<process>/` | Generated stories |
| `stories/<process>/BACKLOG.md` | Story status tracking |
| `docs/CTO_RULES.md` | CTO validation rules |
| `docs/CONTRACT.md` | Story format contract |
| `test-requirements.yaml` | Per-path test requirements |
| `invariants.md` | Project invariants |

## Integration with Quality Kit

BMAD v4.0 integrates:

### Story Generation

Each story now includes:
- Test Requirements section
- Relevant Invariants section

### Gate A (Extended)

```bash
ruff check .                    # Lint
pytest                          # Tests
test-gate.ps1                   # Test requirements
invariant-check.ps1             # Invariant coverage
```

### CTO Guard (Extended)

Now checks:
- Test Requirements present
- Required tests exist
- Invariants covered

## Further Reading

- [Story Format](story-format.md)
- [CTO Review Checklist](../cto-review/checklist.md)
