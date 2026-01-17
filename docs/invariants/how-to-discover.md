# How to Discover Invariants

## The Process

```
1. Analyze Codebase
       ↓
2. Ask Questions
       ↓
3. Document Invariants
       ↓
4. Write NEVER-Tests
```

## Step 1: Analyze Codebase

### Look for Auth Patterns

```bash
# Find auth code
rg "@require_auth|@login_required|middleware" --type py
rg "useAuth|isAuthenticated|authGuard" --type ts
```

Questions:
- Which endpoints are protected?
- What roles exist?
- What data is user-specific?

### Look for Financial Code

```bash
# Find money-related code
rg "price|amount|total|payment|invoice" --type py
```

Questions:
- What values represent money?
- Can they be negative?
- How are refunds handled?

### Look for State Machines

```bash
# Find status/state code
rg "status|state|transition" --type py
rg "enum.*Status" --type py
```

Questions:
- What states exist?
- What transitions are valid?
- Which states are terminal?

## Step 2: Ask Questions

### Security Questions

| Question | Invariant Type |
|----------|----------------|
| What data must NEVER be public? | Auth required |
| What can users NEVER see? | Cross-user protection |
| What can users NEVER do? | Authorization |
| What must NEVER be logged? | Data protection |

### Business Questions

| Question | Invariant Type |
|----------|----------------|
| What values are NEVER negative? | Validation |
| What states are NEVER skipped? | State machine |
| What is NEVER processed twice? | Idempotency |
| What must NEVER be orphaned? | Data integrity |

### Performance Questions

| Question | Invariant Type |
|----------|----------------|
| What is NEVER acceptable latency? | Response time |
| How many queries are NEVER OK? | N+1 prevention |
| What memory is NEVER acceptable? | Resource limits |

## Step 3: Document Invariants

### Format

```markdown
- [ ] **INV-[CAT]-[NUM]**: [What NEVER happens]
  - Test: `[path/to/test_file.py]`
  - Rationale: [Why this matters]
```

### Categories

| Prefix | Category |
|--------|----------|
| SEC | Security |
| BIZ | Business |
| PERF | Performance |
| REL | Reliability |

### Example

```markdown
## Security Invariants

- [ ] **INV-SEC-001**: User data NEVER exposed to other users
  - Test: `tests/invariants/auth/test_never_cross_user.py`
  - Rationale: Privacy, GDPR compliance

- [ ] **INV-SEC-002**: Admin endpoints NEVER accessible without admin role
  - Test: `tests/invariants/auth/test_never_admin_bypass.py`
  - Rationale: Privilege escalation prevention
```

## Using /invariant-discovery

The skill automates this process:

```bash
# In Claude Code
/invariant-discovery
```

It will:
1. Search codebase for patterns
2. Ask you questions
3. Generate invariants.md
4. Request approval

## When to Re-Run Discovery

| Trigger | Action |
|---------|--------|
| New feature with security impact | Add new invariants |
| Security incident | Add invariant to prevent recurrence |
| CTO review finds gap | Add missing invariant |
| Architecture change | Review all invariants |

## Common Discoveries

### E-Commerce

```markdown
- [ ] **INV-BIZ-001**: Cart total NEVER negative
- [ ] **INV-BIZ-002**: Inventory NEVER oversold
- [ ] **INV-BIZ-003**: Orders NEVER processed without payment
```

### SaaS

```markdown
- [ ] **INV-SEC-001**: Tenant A data NEVER visible to Tenant B
- [ ] **INV-BIZ-010**: Subscription NEVER active after cancellation
- [ ] **INV-PERF-001**: Dashboard NEVER takes > 3s
```

### FinTech

```markdown
- [ ] **INV-BIZ-001**: Account balance NEVER negative (unless overdraft)
- [ ] **INV-BIZ-002**: Transactions NEVER lost
- [ ] **INV-SEC-020**: Financial data NEVER logged
```

## Checklist

After discovery:

- [ ] All auth patterns identified
- [ ] All financial logic reviewed
- [ ] All state machines mapped
- [ ] Security questions answered
- [ ] Business rules documented
- [ ] Performance thresholds defined
- [ ] invariants.md created
- [ ] Each invariant has test path

## Further Reading

- [How to Test Invariants](how-to-test.md)
- [Security Questions](../.claude/skills/invariant-discovery/knowledge/security-questions.md)
- [Business Questions](../.claude/skills/invariant-discovery/knowledge/business-questions.md)
