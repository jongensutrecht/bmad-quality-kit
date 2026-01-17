# BMAD Quality Kit - Core Rules

> This document consolidates all rules that the Quality Kit enforces.

---

## Test Gate Rules

### TG-001: Required Tests Must Exist

**Rule**: For each source file that matches a pattern in `test-requirements.yaml`, all required test types must exist.

**Enforcement**: `test-gate.ps1`

**Example**:
```yaml
# test-requirements.yaml
rules:
  - pattern: "components/**"
    required: [unit, playwright]
```

If `components/Button.tsx` changes:
- `Button.test.tsx` must exist (unit)
- `button.spec.ts` must exist (playwright)

---

### TG-002: Test Files Follow Naming Convention

**Rule**: Test files must match source files by naming convention.

**Patterns**:
| Source | Test (Python) | Test (TypeScript) |
|--------|---------------|-------------------|
| `foo.py` | `test_foo.py` or `foo_test.py` | - |
| `Foo.tsx` | - | `Foo.test.tsx` or `Foo.spec.tsx` |

---

### TG-003: Exclusions Are Explicit

**Rule**: Files that don't need tests must be explicitly excluded in `test-requirements.yaml`.

```yaml
exclusions:
  - "**/migrations/**"
  - "**/__init__.py"
```

---

## Invariant Rules

### INV-001: All Invariants Have NEVER-Tests

**Rule**: Every invariant in `invariants.md` must have a corresponding NEVER-test.

**Enforcement**: `invariant-check.ps1`

**Format**:
```markdown
- [ ] **INV-SEC-001**: Description
  - Test: `tests/invariants/auth/test_never_xyz.py`
```

---

### INV-002: NEVER-Test Naming Convention

**Rule**: NEVER-tests must follow the naming pattern:

```
test_NEVER_<what_must_not_happen>
```

Examples:
- `test_NEVER_auth_bypass`
- `test_NEVER_negative_invoice`

---

### INV-003: Invariant ID Format

**Rule**: Invariant IDs follow the format:

```
INV-<CATEGORY>-<NUMBER>
```

| Category | Prefix |
|----------|--------|
| Security | SEC |
| Business | BIZ |
| Performance | PERF |
| Reliability | REL |

---

## Story Rules

### STORY-001: Required Sections

**Rule**: Every story must have these sections:
1. Context
2. Story (Als/Wil ik/Zodat)
3. Test Requirements
4. Relevante Invariants
5. Acceptance Criteria
6. Tasks/Subtasks
7. Touched paths allowlist
8. Dev Notes
9. Dev Agent Record
10. Status

**Enforcement**: `preflight.ps1`

---

### STORY-002: AC Format

**Rule**: Each AC must have:
- Given/When/Then
- CTO Rule reference
- CTO Facet
- Verification command
- Expected output

---

### STORY-003: First and Last Tasks

**Rule**:
- First task: `Lees CLAUDE.md`
- Last task: `Run Gate A checks`

---

### STORY-004: Test Tasks Required

**Rule**: Stories must include:
```
- [ ] Schrijf NEVER-tests voor invariants
- [ ] Schrijf required tests
```

---

## CTO Guard Rules

### CTO-001: Pre-Generation Validation

**Rule**: Before story generation, input must be validated against CTO rules.

**Blocked if**:
- Security violations in design
- Missing architecture considerations

---

### CTO-002: Post-Generation Validation

**Rule**: After story generation, validate:
- All ACs have CTO Rule traceability
- Test Requirements section present
- Verification commands executable

---

### CTO-003: Post-Execution Validation

**Rule**: After story execution, validate:
- No security violations in new code
- Test coverage adequate
- Required tests exist
- Invariants covered

---

## Gate A Rules

### GATE-001: Lint Must Pass

**Rule**: `ruff check .` must exit 0.

---

### GATE-002: Tests Must Pass

**Rule**: `pytest` must exit 0.

---

### GATE-003: Test Requirements Must Pass

**Rule**: `test-gate.ps1` must exit 0.

---

### GATE-004: Invariant Coverage Must Pass

**Rule**: `invariant-check.ps1` must exit 0.

---

## Blocking Behavior

### Hard Block

These cause immediate failure:
- Missing required tests (test-gate)
- Uncovered invariants (invariant-check)
- Hard CTO violations
- Gate A failures

### Soft Block

These generate warnings but allow progress:
- Soft CTO violations (must fix within sprint)
- Coverage below threshold (if not fail_under)

---

## Rule Precedence

1. Security rules (highest)
2. Invariant rules
3. Test rules
4. Code quality rules
5. Documentation rules (lowest)

---

## Overrides

### Per-Project Override

Create `PROJECT_RULES.md` to customize:
```markdown
## Disabled Rules
- TG-002: Custom naming convention in use

## Modified Rules
- GATE-001: Using eslint instead of ruff
```

### Per-Story Override

In story file, add:
```markdown
## Rule Exceptions
- INV-001: Not applicable (data-only change)
  - Justification: [reason]
```

---

Core Rules v1.0.0 - BMAD Quality Kit
