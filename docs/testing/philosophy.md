# Testing Philosophy

## The Problem We're Solving

### "Tests Green, But Doesn't Work"

This is the core problem:
- AI generates code
- AI runs tests: "All tests pass!"
- Feature doesn't work
- Why? The *wrong* tests were run

**Example:**
```
Feature: Dashboard with charts
AI: "pytest passes! Done!"
Reality: No Playwright tests, charts don't render
```

### Why This Happens

1. **AI takes shortcuts** - Runs the easiest tests available
2. **No enforcement** - Nothing says "Playwright MUST run"
3. **Coverage lies** - 80% unit coverage ≠ working feature

### Industry Data

| Statistic | Source |
|-----------|--------|
| 96% of devs don't fully trust AI code | Sonar 2026 |
| 1.7x more issues in AI PRs | CodeRabbit |
| 60% testing gaps | Sonar Survey |

## Our Solution: Explicit Test Requirements

### Per-Path Requirements

Instead of hoping AI picks the right tests, we **specify** them:

```yaml
# test-requirements.yaml
rules:
  - pattern: "components/**"
    required: [unit, playwright]  # BOTH required

  - pattern: "api/**"
    required: [unit, integration, contract]
```

Now:
- Change a component? Playwright MUST exist
- Change an API? Contract test MUST exist
- AI can't skip them

### Invariants

Beyond "tests exist", we define what must **NEVER** happen:

```markdown
# invariants.md
- [ ] **INV-SEC-001**: User data NEVER exposed to other users
- [ ] **INV-BIZ-001**: Invoice totals NEVER negative
```

Each invariant MUST have a NEVER-test.

## The Test Pyramid (Extended)

```
            /\
           /  \
          / E2E \
         /________\        ← Playwright, Cypress
        /          \
       / Integration\      ← DB, API
      /______________\
     /                \
    /      Unit        \   ← Fast, isolated
   /____________________\
  /                      \
 /   NEVER-Tests (base)   \  ← Invariants
/____________________________\
```

NEVER-tests form the foundation - they guarantee nothing breaks.

## Principles

### 1. Specify, Don't Hope

```yaml
# Bad: Hope AI runs playwright
- pattern: "components/**"

# Good: Require playwright
- pattern: "components/**"
  required: [unit, playwright]
```

### 2. Enforce, Don't Trust

```bash
# Bad: "Run tests"
pytest

# Good: Gate checks ALL requirements
pytest && test-gate.ps1 && invariant-check.ps1
```

### 3. Block, Don't Warn

```powershell
# Bad: Warning (ignored)
Write-Warning "Missing playwright test"

# Good: Block (can't ignore)
exit 1  # CI fails, merge blocked
```

### 4. Test Behavior, Not Implementation

```python
# Bad: Tests implementation details
def test_uses_hashlib():
    assert "hashlib" in inspect.getsource(hash_password)

# Good: Tests behavior
def test_password_hash_is_not_plaintext():
    result = hash_password("secret123")
    assert result != "secret123"
```

### 5. NEVER > SHOULD

```python
# SHOULD: User can log in (positive)
def test_user_can_login():
    response = login("user", "password")
    assert response.status == 200

# NEVER: More important
def test_NEVER_login_without_password():
    response = login("user", "")
    assert response.status == 401
```

## How We Enforce It

### Layer 1: Specification

- `test-requirements.yaml` - Which tests per path
- `invariants.md` - What must NEVER happen

### Layer 2: AI Guidance

- `/test-guard` skill reads specs
- AI knows what tests to write
- AI is blocked if tests missing

### Layer 3: CLI Tools

- `test-gate.ps1` - Checks test requirements
- `invariant-check.ps1` - Checks invariant coverage

### Layer 4: CI/CD

- Runs before merge
- Blocks if failed
- No exceptions

## Outcome

| Before | After |
|--------|-------|
| "Tests pass" (but wrong tests) | "Required tests pass" |
| Hope AI tests correctly | Enforce what's required |
| Discover bugs in production | Catch at gate |
| "I didn't test that" | "Gate blocked it" |

## Further Reading

- [Test Pyramid](test-pyramid.md)
- [When Playwright](when-playwright.md)
- [What Are Invariants](../invariants/what-are-invariants.md)
