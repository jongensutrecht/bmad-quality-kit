# CTO Review Checklist

## Overview

The CTO Review validates work against CTO rules at key checkpoints.

## When to Run

| Checkpoint | When | Purpose |
|------------|------|---------|
| CTO Guard #1 | Before story generation | Validate input |
| CTO Guard #2 | After story generation | Validate stories |
| CTO Guard #3 | After story execution | Validate code |

## Invocation

```bash
# Manual
/cto-guard

# Automatic (in BMAD)
# Runs at checkpoints automatically
```

## Output Format

### 1. CTO Rules Applied

```markdown
## 1. CTO RULES APPLIED

| Rule ID | Rule Description |
|---------|------------------|
| SEC-001 | No public mutating endpoints |
| TEST-001 | All code has tests |
```

### 2. Traceability Map

```markdown
## 2. TRACEABILITY MAP

| Rule ID | Covered? | Evidence |
|---------|----------|----------|
| SEC-001 | ✅ YES | `api/routes.py:15` - auth required |
| TEST-001 | ❌ NO | No tests for new function |
```

### 3. Violations

```markdown
## 3. VIOLATIONS

### Hard Violations (MUST FIX)
| ID | Rule | Violation | Location |
|----|------|-----------|----------|
| V1 | SEC-001 | Public mutation | `api/data.py:42` |

### Soft Violations (FIX OR JUSTIFY)
| ID | Rule | Violation | Location |
|----|------|-----------|----------|
| V2 | DOC-001 | Missing docstring | `utils/helper.py:10` |
```

### 4. Test Compliance (v2.0)

```markdown
## 4. TEST COMPLIANCE

### Test Requirements Check
| File | Required Tests | Present | Status |
|------|---------------|---------|--------|
| Button.tsx | unit, playwright | unit | ❌ |

### Invariant Coverage Check
| Invariant ID | NEVER-Test | Status |
|--------------|------------|--------|
| INV-SEC-001 | test_never_auth.py | ✅ OK |
| INV-BIZ-001 | - | ❌ MISSING |
```

### 5. Required Actions

```markdown
## 5. REQUIRED ACTIONS

| Action | Priority | Details |
|--------|----------|---------|
| Add auth | P1 | Add `@require_auth` to `/data` |
| Add playwright | P1 | Create `Button.spec.ts` |

**STATUS**: ❌ BLOCKED
```

### 6. Verdict

```markdown
## 6. CTO COMPLIANCE VERDICT

### ❌ NON-COMPLIANT

**Reason**:
- 1 hard violation (SEC-001)
- 1 missing test type

**Next Steps**:
1. Fix violations
2. Re-run `/cto-guard`
```

## Verdicts

| Verdict | Meaning | Action |
|---------|---------|--------|
| ✅ COMPLIANT | All rules pass | Proceed |
| ⚠️ CONDITIONAL | Soft violations | Proceed, fix later |
| ❌ NON-COMPLIANT | Hard violations | BLOCKED |

## Rule Categories

### Security (SEC)

| Rule | Description |
|------|-------------|
| SEC-001 | No public mutating endpoints |
| SEC-002 | Auth required for sensitive data |
| SEC-003 | Input validation required |

### Testing (TEST)

| Rule | Description |
|------|-------------|
| TEST-001 | All code has tests |
| TEST-002 | Required test types present |
| TEST-003 | Minimum coverage thresholds |

### Invariants (INV)

| Rule | Description |
|------|-------------|
| INV-001 | All invariants have NEVER-tests |
| INV-002 | Stories link to relevant invariants |

### Code Quality (CODE)

| Rule | Description |
|------|-------------|
| CODE-001 | No lint errors |
| CODE-002 | Type annotations |
| CODE-003 | Docstrings for public API |

### Operations (OPS)

| Rule | Description |
|------|-------------|
| OPS-001 | Logging for critical paths |
| OPS-002 | Error handling |
| OPS-003 | Health endpoints |

## Defining Custom Rules

Add to `docs/CTO_RULES.md`:

```markdown
## Custom Rules

### CUSTOM-001: Feature Flags Required
- **Scope**: All new features
- **Requirement**: New features behind feature flag
- **Rationale**: Safe rollout

### CUSTOM-002: API Versioning
- **Scope**: Public API changes
- **Requirement**: Version in URL path
- **Rationale**: Backward compatibility
```

## Checklist for Stories

Before marking story complete:

- [ ] CTO Guard #3 passes
- [ ] All hard violations resolved
- [ ] Soft violations documented/justified
- [ ] Test requirements met
- [ ] Invariant coverage verified

## Checklist for PRs

Before merge:

- [ ] CTO Guard passes in CI
- [ ] Gate A (ruff + pytest + test-gate + invariant-check) passes
- [ ] No ❌ NON-COMPLIANT verdict
- [ ] All P1 actions addressed
