# When to Use Playwright

## Quick Decision

```
Is there UI/browser interaction?
├─► YES → Playwright required
└─► NO  → Not needed
```

## Scenarios Requiring Playwright

### 1. UI Components

Any component that renders in the browser:

```
components/
├── Button.tsx     → Needs playwright
├── Modal.tsx      → Needs playwright
├── DataGrid.tsx   → Needs playwright
└── hooks/
    └── useAuth.ts → Unit test only
```

### 2. Pages

Full page renders:

```
pages/
├── Dashboard.tsx  → Needs playwright
├── Login.tsx      → Needs playwright
└── api/
    └── users.ts   → Integration test (no playwright)
```

### 3. User Flows

Multi-step interactions:

- Login flow
- Checkout process
- Form submissions
- Navigation

### 4. Visual Elements

Anything that needs visual verification:

- Charts and graphs
- Responsive layouts
- Animations
- Theme switching

## When NOT Needed

### 1. Backend Code

```python
# No UI, no playwright
def calculate_tax(amount, rate):
    return amount * rate
```

### 2. Pure Utilities

```typescript
// No UI, no playwright
export function formatCurrency(amount: number): string {
    return `$${amount.toFixed(2)}`;
}
```

### 3. API Endpoints

```python
# Integration test, not playwright
@app.get("/api/users")
def list_users():
    return db.query(User).all()
```

### 4. Data Models

```python
# Unit test, not playwright
class User(BaseModel):
    email: str
    name: str
```

## Decision Matrix

| Type | Unit | Integration | Playwright |
|------|------|-------------|------------|
| React Component | ✅ | - | ✅ |
| Vue Component | ✅ | - | ✅ |
| Page Route | ✅ | - | ✅ |
| API Endpoint | ✅ | ✅ | - |
| Database Model | ✅ | ✅ | - |
| Utility Function | ✅ | - | - |
| Business Logic | ✅ | - | - |
| Form Validation | ✅ | - | ✅ |
| Auth Flow | ✅ | ✅ | ✅ |

## Configuration

### test-requirements.yaml

```yaml
rules:
  # All UI components need playwright
  - pattern: "components/**"
    required: [unit, playwright]

  - pattern: "src/components/**"
    required: [unit, playwright]

  # Pages need playwright
  - pattern: "pages/**"
    required: [unit, playwright]

  - pattern: "src/pages/**"
    required: [unit, playwright]

  # Views (alternative naming)
  - pattern: "views/**"
    required: [unit, playwright]

  # Backend - no playwright
  - pattern: "api/**"
    required: [unit, integration]

  - pattern: "services/**"
    required: [unit, integration]
```

## Common Mistakes

### ❌ Testing Business Logic with Playwright

```typescript
// BAD: Slow, unnecessary
test('calculate tax', async ({ page }) => {
  await page.goto('/tax-calculator');
  await page.fill('#amount', '100');
  await page.click('#calculate');
  await expect(page.locator('#result')).toHaveText('21');
});
```

```python
# GOOD: Fast unit test
def test_calculate_tax():
    assert calculate_tax(100, 0.21) == 21
```

### ❌ Skipping Playwright for UI

```typescript
// BAD: Only tests props, not rendering
describe('Button', () => {
  it('has label', () => {
    const button = new Button({ label: 'Click' });
    expect(button.props.label).toBe('Click');
  });
});
```

```typescript
// GOOD: Tests actual rendering
test('button displays label', async ({ page }) => {
  await page.goto('/storybook/button');
  await expect(page.locator('button')).toHaveText('Click');
});
```

### ❌ Too Many Playwright Tests

```typescript
// BAD: Testing every permutation
test('button with size=small', ...);
test('button with size=medium', ...);
test('button with size=large', ...);
test('button with variant=primary', ...);
test('button with variant=secondary', ...);
// ... 50 more tests
```

```typescript
// GOOD: Test representative cases
test('button renders in all sizes', async ({ page }) => {
  // Test a few key variants
});

// Use unit tests for prop combinations
describe('Button', () => {
  it.each(['small', 'medium', 'large'])('accepts size=%s', (size) => {
    // Unit test
  });
});
```

## Playwright Best Practices

### 1. Use data-testid

```html
<button data-testid="submit-btn">Submit</button>
```

```typescript
await page.click('[data-testid="submit-btn"]');
```

### 2. Wait for Elements

```typescript
// Good
await expect(page.locator('.loading')).not.toBeVisible();
await page.click('button');

// Bad
await page.click('button');  // Might click before ready
```

### 3. Mock APIs

```typescript
await page.route('/api/users', (route) => {
  route.fulfill({ json: [{ id: 1, name: 'Test' }] });
});
```

### 4. Test User Flows, Not Implementation

```typescript
// Good: Tests what user does
test('user can add item to cart', async ({ page }) => {
  await page.goto('/products');
  await page.click('[data-testid="add-to-cart"]');
  await expect(page.locator('.cart-badge')).toHaveText('1');
});

// Bad: Tests implementation
test('clicking button calls addToCart', async ({ page }) => {
  // This is what unit tests are for
});
```

## Further Reading

- [Test Pyramid](test-pyramid.md)
- [Playwright Examples](../.claude/skills/test-guard/knowledge/examples/playwright-example.md)
