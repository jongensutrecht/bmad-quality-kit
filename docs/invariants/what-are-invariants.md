# What Are Invariants?

## Definition

An **invariant** is a condition that must **NEVER** be violated. Unlike regular tests that check something works, invariant tests check that something **NEVER** fails.

## Examples

| Invariant | Meaning |
|-----------|---------|
| User data NEVER exposed to other users | Privacy protection |
| Invoice totals NEVER negative | Financial integrity |
| API response NEVER exceeds 500ms | Performance guarantee |
| Auth bypass NEVER possible | Security |

## Why Invariants Matter

### Traditional Tests

```python
# Tests that something WORKS
def test_user_can_login():
    response = login("user@example.com", "password")
    assert response.status == 200
```

This is good, but what about:
- Login without password?
- Login with someone else's session?
- Login after account deletion?

### Invariant Tests

```python
# Tests that something NEVER happens
def test_NEVER_login_without_password():
    response = login("user@example.com", "")
    assert response.status == 401

def test_NEVER_access_other_user_session():
    session = create_session(user_a)
    response = get_data(session, user_b.id)
    assert response.status == 403
```

These guarantee security boundaries.

## Categories

### Security Invariants

Conditions that if violated, cause security breaches:

- Authentication bypass
- Authorization failures
- Data leaks
- Injection vulnerabilities

```markdown
## Security Invariants

- [ ] **INV-SEC-001**: Auth endpoints NEVER return data without valid token
- [ ] **INV-SEC-002**: User data NEVER exposed to other users
- [ ] **INV-SEC-003**: Passwords NEVER stored in plaintext
```

### Business Invariants

Rules that if violated, break business logic:

- Invalid financial calculations
- Impossible state transitions
- Data integrity violations

```markdown
## Business Invariants

- [ ] **INV-BIZ-001**: Invoice totals NEVER negative
- [ ] **INV-BIZ-002**: Orders NEVER skip states
- [ ] **INV-BIZ-003**: Refunds NEVER exceed payment
```

### Performance Invariants

Thresholds that if exceeded, break SLAs:

- Response time limits
- Resource consumption
- Query counts

```markdown
## Performance Invariants

- [ ] **INV-PERF-001**: API response NEVER exceeds 500ms p99
- [ ] **INV-PERF-002**: Queries NEVER exceed 100 per request
```

### Reliability Invariants

Conditions for system stability:

- Error handling
- Data consistency
- Transaction integrity

```markdown
## Reliability Invariants

- [ ] **INV-REL-001**: Unhandled exceptions NEVER crash server
- [ ] **INV-REL-002**: Partial writes NEVER corrupt state
```

## The NEVER Principle

When writing invariant tests:

1. **Ask**: What must NEVER happen?
2. **Write**: Test that attempts the forbidden action
3. **Assert**: Verify it fails correctly

```python
def test_NEVER_[what_must_not_happen]():
    # Attempt the forbidden action
    result = attempt_forbidden_action()

    # Verify it was prevented
    assert result.prevented == True
```

## Relationship to Test Requirements

| Concept | Question | File |
|---------|----------|------|
| Test Requirements | Which tests are needed? | `test-requirements.yaml` |
| Invariants | What must NEVER happen? | `invariants.md` |

Both are enforced:
- `test-gate.ps1` checks test requirements
- `invariant-check.ps1` checks invariant coverage

## Creating invariants.md

Use `/invariant-discovery` to:

1. Analyze your codebase
2. Answer discovery questions
3. Generate initial invariants
4. Review and approve

## Further Reading

- [How to Discover Invariants](how-to-discover.md)
- [How to Test Invariants](how-to-test.md)
- [NEVER-Test Patterns](../.claude/skills/test-guard/knowledge/invariant-patterns.md)
