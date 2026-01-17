# The Test Pyramid

## Overview

```
                    /\
                   /  \
                  / E2E \           10%
                 /________\         Slow, expensive
                /          \
               / Integration\       20%
              /______________\      Medium
             /                \
            /      Unit        \    70%
           /____________________\   Fast, cheap
```

## Layers

### Unit Tests (Base - 70%)

**What**: Test individual functions/classes in isolation.

**Characteristics**:
- No external dependencies
- Mock everything
- Fast (< 100ms per test)
- Deterministic

**When to use**:
- Pure business logic
- Utility functions
- Data transformations
- Validation

**Example**:
```python
def test_calculate_discount():
    result = calculate_discount(100, percent=10)
    assert result == 90
```

### Integration Tests (Middle - 20%)

**What**: Test interaction between components.

**Characteristics**:
- Real database (test container)
- Real API calls (mock server or test env)
- Slower than unit
- Tests happy path + errors

**When to use**:
- Database operations
- API endpoints
- Service layer
- External integrations

**Example**:
```python
def test_order_creates_payment_record(db):
    order = create_order(db, items=[...])
    payment = db.query(Payment).filter_by(order_id=order.id).first()
    assert payment is not None
```

### E2E Tests (Top - 10%)

**What**: Test complete user flows.

**Characteristics**:
- Real browser
- Full application stack
- Slowest
- Most expensive
- Most realistic

**When to use**:
- Critical user journeys
- Complex interactions
- Visual verification
- Cross-browser testing

**Example**:
```typescript
test('user can complete checkout', async ({ page }) => {
  await page.goto('/cart');
  await page.click('[data-testid="checkout"]');
  await page.fill('#email', 'test@example.com');
  await page.click('[data-testid="pay"]');
  await expect(page.locator('.success')).toBeVisible();
});
```

## Adding NEVER-Tests

The pyramid extends downward:

```
           /\
          /  \
         /E2E \
        /______\
       /        \
      /Integr.   \
     /____________\
    /              \
   /     Unit       \
  /__________________\
 /                    \
/    NEVER-Tests       \   ← Foundation
/________________________\
```

NEVER-tests are foundational - they ensure invariants hold.

## Anti-Patterns

### Ice Cream Cone

```
     /____________\
    /    E2E       \    ← Too many
   /______________  \
  /   Integration    \  ← Some
 /____________________\
/        Unit          \ ← Too few
```

**Problem**: Slow, flaky, expensive test suite.

### Cupcake

```
    /\       /\       /\
   /  \     /  \     /  \
  / E2E\   /E2E \   /E2E \
```

**Problem**: Multiple isolated E2E suites, no unit tests.

### Hourglass

```
           /\
          /  \
         /E2E \
        /______\  ← Gap
       /        \
      /          \
     /            \
    /______________\
   /    Unit        \
  /__________________\
```

**Problem**: Missing integration layer, things break when connected.

## Mapping to Our System

### test-requirements.yaml

```yaml
rules:
  # Pure logic → unit only
  - pattern: "lib/**"
    required: [unit]

  # DB access → unit + integration
  - pattern: "repositories/**"
    required: [unit, integration]

  # API → all three
  - pattern: "api/**"
    required: [unit, integration, contract]

  # UI → unit + e2e
  - pattern: "components/**"
    required: [unit, playwright]
```

### Coverage Distribution

Aim for:
- 80%+ line coverage from unit tests
- 60%+ from integration tests
- E2E covers critical paths (10-20 flows)
- 100% invariants have NEVER-tests

## Making the Right Choice

```
Question: What am I testing?
│
├─► Pure function, no deps?
│   └─► Unit test
│
├─► Talks to database?
│   └─► Integration test
│
├─► Browser interaction?
│   └─► Playwright/E2E test
│
├─► Something must NEVER happen?
│   └─► NEVER-test (invariant)
│
└─► API schema/contract?
    └─► Contract test
```

## Further Reading

- [When Playwright](when-playwright.md)
- [Writing Good Tests](writing-good-tests.md)
