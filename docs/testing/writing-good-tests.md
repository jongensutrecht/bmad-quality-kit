# Writing Good Tests

## Core Principles

### 1. Test Behavior, Not Implementation

```python
# BAD: Tests implementation
def test_uses_sha256():
    import inspect
    source = inspect.getsource(hash_password)
    assert "sha256" in source

# GOOD: Tests behavior
def test_hash_is_not_reversible():
    hashed = hash_password("secret123")
    assert hashed != "secret123"
    assert len(hashed) == 64  # SHA-256 length
```

### 2. Arrange-Act-Assert

```python
def test_order_total():
    # Arrange
    order = Order()
    order.add_item(Product(price=10), qty=2)
    order.add_item(Product(price=5), qty=1)

    # Act
    total = order.calculate_total()

    # Assert
    assert total == 25
```

### 3. One Logical Assertion Per Test

```python
# BAD: Multiple unrelated assertions
def test_user():
    user = create_user(name="John", email="john@example.com")
    assert user.name == "John"
    assert user.email == "john@example.com"
    assert user.id is not None
    assert user.created_at is not None

# GOOD: Split into logical units
def test_user_stores_name():
    user = create_user(name="John")
    assert user.name == "John"

def test_user_stores_email():
    user = create_user(email="john@example.com")
    assert user.email == "john@example.com"

def test_user_gets_id():
    user = create_user()
    assert user.id is not None
```

### 4. Descriptive Names

```python
# BAD
def test_order_1():
    ...

def test_user_validation():
    ...

# GOOD
def test_order_total_includes_tax():
    ...

def test_user_email_must_be_valid():
    ...

def test_NEVER_negative_order_total():
    ...
```

### 5. Tests Are Documentation

```python
def test_refund_cannot_exceed_payment():
    """
    Business Rule: Refunds must not exceed original payment.

    Given: A payment of $100
    When: Attempting to refund $150
    Then: ValueError is raised
    """
    payment = create_payment(amount=100)

    with pytest.raises(ValueError, match="exceeds"):
        refund(payment, amount=150)
```

## Common Patterns

### Parameterized Tests

```python
@pytest.mark.parametrize("input,expected", [
    ("", False),
    ("invalid", False),
    ("test@example.com", True),
    ("test@sub.example.com", True),
])
def test_is_valid_email(input, expected):
    assert is_valid_email(input) == expected
```

### Fixtures for Setup

```python
@pytest.fixture
def authenticated_client():
    client = TestClient(app)
    token = create_test_token()
    client.headers["Authorization"] = f"Bearer {token}"
    return client

def test_get_profile(authenticated_client):
    response = authenticated_client.get("/api/profile")
    assert response.status_code == 200
```

### Factory Functions

```python
def create_user(**overrides):
    defaults = {
        "name": "Test User",
        "email": "test@example.com",
        "password": "password123"
    }
    return User(**{**defaults, **overrides})

def test_user_name():
    user = create_user(name="Custom Name")
    assert user.name == "Custom Name"
```

## NEVER-Test Patterns

### Auth Bypass Prevention

```python
def test_NEVER_access_without_token(client):
    response = client.get("/api/protected")
    assert response.status_code == 401

def test_NEVER_access_with_expired_token(client, expired_token):
    response = client.get(
        "/api/protected",
        headers={"Authorization": f"Bearer {expired_token}"}
    )
    assert response.status_code == 401
```

### Cross-User Data

```python
def test_NEVER_see_other_user_data(client, user_a, user_b):
    response = client.get(
        f"/api/users/{user_b.id}",
        headers={"Authorization": f"Bearer {user_a.token}"}
    )
    assert response.status_code == 403
```

### Negative Values

```python
def test_NEVER_negative_invoice(invoice_service):
    with pytest.raises(ValueError, match="negative"):
        invoice_service.create(items=[{"amount": -100}])
```

## Anti-Patterns

### 1. Testing the Framework

```python
# BAD: Testing Python works
def test_dict_has_key():
    d = {"key": "value"}
    assert "key" in d
```

### 2. Excessive Mocking

```python
# BAD: Mocking everything
def test_create_order(mock_db, mock_payment, mock_email, mock_inventory):
    # What are we even testing?
    ...

# GOOD: Mock only external services
def test_create_order(db, mock_payment_gateway):
    # Tests real logic with real DB
    ...
```

### 3. Fragile Selectors

```typescript
// BAD: Fragile CSS path
await page.click('div.container > ul > li:nth-child(3) > button');

// GOOD: Stable test ID
await page.click('[data-testid="add-to-cart"]');
```

### 4. Sleep Statements

```typescript
// BAD: Arbitrary wait
await page.click('button');
await page.waitForTimeout(2000);  // Hope it loaded
expect(page.locator('.result')).toBeVisible();

// GOOD: Wait for condition
await page.click('button');
await expect(page.locator('.result')).toBeVisible();
```

### 5. Shared State

```python
# BAD: Tests depend on each other
class TestUser:
    user = None

    def test_create(self):
        self.user = create_user()

    def test_update(self):
        update_user(self.user, name="New")  # Fails if run alone

# GOOD: Independent tests
def test_create():
    user = create_user()
    assert user.id is not None

def test_update():
    user = create_user()  # Own setup
    update_user(user, name="New")
    assert user.name == "New"
```

## Coverage Guidelines

### What to Cover

- ✅ Business logic (100%)
- ✅ Edge cases
- ✅ Error handling
- ✅ Security paths
- ✅ Integration points

### What to Skip

- ❌ Getters/setters without logic
- ❌ Framework code
- ❌ Third-party library internals
- ❌ Configuration files

## Checklist

Before submitting tests:

- [ ] Tests have descriptive names
- [ ] Each test is independent
- [ ] No hardcoded waits/sleeps
- [ ] Fixtures used for common setup
- [ ] Error cases tested
- [ ] NEVER-tests for invariants
- [ ] Tests pass in isolation
- [ ] Tests pass in CI

## Further Reading

- [Test Types](../.claude/skills/test-guard/knowledge/test-types.md)
- [NEVER-Test Patterns](../.claude/skills/test-guard/knowledge/invariant-patterns.md)
