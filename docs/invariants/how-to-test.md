# How to Test Invariants

## The NEVER-Test Pattern

NEVER-tests validate that forbidden conditions are prevented.

### Structure

```python
def test_NEVER_<what_must_not_happen>():
    """
    Invariant: INV-XXX-NNN
    <Description of what must NEVER happen>
    """
    # Attempt the forbidden action
    result = attempt_forbidden_action()

    # Verify it was prevented
    assert result.prevented == True
```

### Naming Convention

```
test_NEVER_<action_that_must_not_happen>
```

Examples:
- `test_NEVER_access_without_auth`
- `test_NEVER_negative_invoice`
- `test_NEVER_skip_order_status`

## Test Categories

### Auth Bypass Tests

```python
# INV-SEC-001: Protected endpoints NEVER return data without token

class TestNeverAuthBypass:
    """Invariant: Auth bypass is NEVER possible."""

    @pytest.mark.parametrize("endpoint", ["/api/users", "/api/orders"])
    async def test_NEVER_access_without_token(self, client, endpoint):
        response = await client.get(endpoint)
        assert response.status_code == 401

    async def test_NEVER_access_with_expired_token(self, client, expired_token):
        response = await client.get(
            "/api/users",
            headers={"Authorization": f"Bearer {expired_token}"}
        )
        assert response.status_code == 401
```

### Cross-User Tests

```python
# INV-SEC-002: User data NEVER exposed to other users

class TestNeverCrossUser:
    """Invariant: Cross-user data access is NEVER possible."""

    async def test_NEVER_view_other_user_profile(
        self, client, user_a_token, user_b
    ):
        response = await client.get(
            f"/api/users/{user_b.id}",
            headers={"Authorization": f"Bearer {user_a_token}"}
        )
        assert response.status_code in [403, 404]

    async def test_NEVER_modify_other_user_data(
        self, client, user_a_token, user_b
    ):
        response = await client.put(
            f"/api/users/{user_b.id}",
            json={"name": "Hacked"},
            headers={"Authorization": f"Bearer {user_a_token}"}
        )
        assert response.status_code in [403, 404]
```

### Negative Value Tests

```python
# INV-BIZ-001: Invoice totals NEVER negative

class TestNeverNegative:
    """Invariant: Financial values are NEVER negative."""

    def test_NEVER_create_negative_invoice(self, invoice_service):
        with pytest.raises(ValueError, match="negative"):
            invoice_service.create(
                items=[{"amount": -100}]
            )

    def test_NEVER_refund_exceeds_payment(self, payment_service, payment):
        with pytest.raises(ValueError, match="exceeds"):
            payment_service.refund(
                payment.id,
                amount=payment.amount + 1
            )
```

### State Machine Tests

```python
# INV-BIZ-010: Order status NEVER skips intermediate states

INVALID_TRANSITIONS = [
    ("pending", "shipped"),    # Skips confirmed
    ("pending", "delivered"),  # Skips multiple
    ("delivered", "pending"),  # Reversal
]

class TestNeverSkipStatus:
    """Invariant: Invalid state transitions are NEVER allowed."""

    @pytest.mark.parametrize("from_status,to_status", INVALID_TRANSITIONS)
    def test_NEVER_invalid_transition(
        self, order_service, order, from_status, to_status
    ):
        order.status = from_status

        with pytest.raises(ValueError, match="Invalid transition"):
            order_service.update_status(order.id, to_status)
```

## Directory Structure

```
tests/
└── invariants/
    ├── __init__.py
    ├── conftest.py          # Shared fixtures
    │
    ├── auth/
    │   ├── __init__.py
    │   ├── test_never_auth_bypass.py
    │   └── test_never_cross_user.py
    │
    ├── security/
    │   ├── __init__.py
    │   └── test_never_injection.py
    │
    ├── business/
    │   ├── __init__.py
    │   ├── test_never_negative.py
    │   └── test_never_skip_status.py
    │
    └── performance/
        ├── __init__.py
        └── test_never_slow.py
```

## Running NEVER-Tests

```bash
# All invariant tests
pytest tests/invariants/ -v

# Specific category
pytest tests/invariants/auth/ -v

# With coverage
pytest tests/invariants/ --cov=src --cov-report=html

# Fail fast
pytest tests/invariants/ -x
```

## Assertion Messages

Include invariant ID in assertion messages:

```python
assert response.status_code == 401, (
    f"INVARIANT VIOLATION [INV-SEC-001]: "
    f"Endpoint returned {response.status_code} without token"
)
```

This makes failures immediately identifiable.

## Fixtures

Common fixtures for invariant tests:

```python
# tests/invariants/conftest.py

@pytest.fixture
async def client():
    """HTTP client for API testing."""
    async with AsyncClient(app=app, base_url="http://test") as c:
        yield c

@pytest.fixture
def user_a():
    """Create test user A."""
    return create_user(email="a@test.com")

@pytest.fixture
def user_a_token(user_a):
    """JWT token for user A."""
    return create_token(user_a)

@pytest.fixture
def user_b():
    """Create test user B."""
    return create_user(email="b@test.com")

@pytest.fixture
def expired_token():
    """Expired JWT token."""
    return create_token(expires_in=-3600)
```

## Updating invariants.md

After writing tests, update the checkbox:

```markdown
# Before
- [ ] **INV-SEC-001**: Auth bypass NEVER possible
  - Test: `tests/invariants/auth/test_never_auth_bypass.py`

# After
- [x] **INV-SEC-001**: Auth bypass NEVER possible
  - Test: `tests/invariants/auth/test_never_auth_bypass.py`
```

## Verification

Run invariant-check to verify coverage:

```powershell
pwsh tools/invariant-check/invariant-check.ps1 -RepoRoot .
```

## Checklist

For each invariant:

- [ ] Test file created in `tests/invariants/<category>/`
- [ ] Test name starts with `test_NEVER_`
- [ ] Invariant ID in docstring or comments
- [ ] Assertion message includes invariant ID
- [ ] Checkbox updated in invariants.md
- [ ] invariant-check passes

## Further Reading

- [NEVER-Test Patterns](../.claude/skills/test-guard/knowledge/invariant-patterns.md)
- [Complete Example](../.claude/skills/test-guard/knowledge/examples/never-test-example.md)
