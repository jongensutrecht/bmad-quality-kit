# Project Invariants

> Dit document beschrijft wat NOOIT mag gebeuren in dit project.
> Elke invariant MOET een bijbehorende NEVER-test hebben.

---

## Hoe dit document te gebruiken

1. Elke invariant is een conditie die NOOIT mag worden geschonden
2. Markeer invarianten met `- [ ]` als de test nog ontbreekt
3. Markeer invarianten met `- [x]` als de test bestaat
4. Voeg het test bestand pad toe bij elke invariant

---

## Security Invariants

> Condities die NOOIT mogen worden geschonden vanwege security.

### Authentication

- [ ] **INV-SEC-001**: Authenticated endpoints NEVER return data without valid token
  - Test: `tests/invariants/auth/test_never_data_without_token.py`

- [ ] **INV-SEC-002**: User data is NEVER exposed to other users
  - Test: `tests/invariants/auth/test_never_cross_user_data.py`

- [ ] **INV-SEC-003**: Admin endpoints are NEVER accessible without admin role
  - Test: `tests/invariants/auth/test_never_admin_without_role.py`

### Data Protection

- [ ] **INV-SEC-010**: Passwords are NEVER stored in plaintext
  - Test: `tests/invariants/security/test_never_plaintext_passwords.py`

- [ ] **INV-SEC-011**: Sensitive data is NEVER logged
  - Test: `tests/invariants/security/test_never_sensitive_logs.py`

- [ ] **INV-SEC-012**: API keys are NEVER exposed in responses
  - Test: `tests/invariants/security/test_never_exposed_api_keys.py`

### Input Validation

- [ ] **INV-SEC-020**: SQL injection is NEVER possible
  - Test: `tests/invariants/security/test_never_sql_injection.py`

- [ ] **INV-SEC-021**: XSS is NEVER possible in user input
  - Test: `tests/invariants/security/test_never_xss.py`

---

## Business Invariants

> Business rules die NOOIT mogen worden geschonden.

### Financial

- [ ] **INV-BIZ-001**: Invoice totals are NEVER negative
  - Test: `tests/invariants/business/test_never_negative_invoice.py`

- [ ] **INV-BIZ-002**: Payments are NEVER processed twice for same invoice
  - Test: `tests/invariants/business/test_never_duplicate_payment.py`

- [ ] **INV-BIZ-003**: Refunds NEVER exceed original payment amount
  - Test: `tests/invariants/business/test_never_over_refund.py`

### State Machine

- [ ] **INV-BIZ-010**: Order status NEVER skips intermediate states
  - Test: `tests/invariants/business/test_never_skip_order_status.py`

- [ ] **INV-BIZ-011**: Completed orders are NEVER modified
  - Test: `tests/invariants/business/test_never_modify_completed.py`

- [ ] **INV-BIZ-012**: Deleted items are NEVER restored without audit
  - Test: `tests/invariants/business/test_never_restore_without_audit.py`

### Data Integrity

- [ ] **INV-BIZ-020**: Parent-child relationships are NEVER orphaned
  - Test: `tests/invariants/business/test_never_orphaned_relations.py`

- [ ] **INV-BIZ-021**: Unique constraints are NEVER violated
  - Test: `tests/invariants/business/test_never_duplicate_unique.py`

---

## Performance Invariants

> Performance grenzen die NOOIT mogen worden overschreden.

### Response Times

- [ ] **INV-PERF-001**: API responses NEVER exceed 500ms p99
  - Test: `tests/invariants/performance/test_never_slow_api.py`

- [ ] **INV-PERF-002**: Page load NEVER exceeds 3 seconds
  - Test: `tests/invariants/performance/test_never_slow_page.py`

### Resource Usage

- [ ] **INV-PERF-010**: Memory usage NEVER exceeds 512MB per request
  - Test: `tests/invariants/performance/test_never_memory_leak.py`

- [ ] **INV-PERF-011**: Database queries NEVER exceed 100 per request
  - Test: `tests/invariants/performance/test_never_n_plus_one.py`

### Concurrency

- [ ] **INV-PERF-020**: Race conditions NEVER cause data corruption
  - Test: `tests/invariants/performance/test_never_race_condition.py`

- [ ] **INV-PERF-021**: Deadlocks NEVER occur in transaction code
  - Test: `tests/invariants/performance/test_never_deadlock.py`

---

## Reliability Invariants

> Condities voor system reliability.

### Error Handling

- [ ] **INV-REL-001**: Unhandled exceptions NEVER crash the server
  - Test: `tests/invariants/reliability/test_never_crash.py`

- [ ] **INV-REL-002**: Database errors NEVER leave transactions open
  - Test: `tests/invariants/reliability/test_never_open_transaction.py`

### Data Consistency

- [ ] **INV-REL-010**: Partial writes NEVER corrupt state
  - Test: `tests/invariants/reliability/test_never_partial_corruption.py`

- [ ] **INV-REL-011**: Failed operations NEVER leave side effects
  - Test: `tests/invariants/reliability/test_never_side_effects.py`

---

## Discovery Questions

> Gebruik deze vragen om nieuwe invarianten te ontdekken:

### Security
- Welke data mag NOOIT zonder authenticatie zichtbaar zijn?
- Welke acties zijn NOOIT reversible?
- Welke endpoints mogen NOOIT publiek zijn?
- Welke data mag NOOIT gelogd worden?

### Business
- Welke waarden mogen NOOIT negatief zijn?
- Welke state transitions zijn NOOIT toegestaan?
- Welke data mag NOOIT inconsistent zijn?
- Welke operaties mogen NOOIT dubbel uitgevoerd worden?

### Performance
- Welke response times zijn NOOIT acceptabel?
- Welke memory usage is NOOIT OK?
- Welke query counts zijn NOOIT acceptabel?

### Reliability
- Welke fouten mogen NOOIT onafgehandeld blijven?
- Welke operaties mogen NOOIT half afgemaakt blijven?
- Welke data mogen NOOIT verloren gaan?

---

## Changelog

| Datum | Wijziging | Door |
|-------|-----------|------|
| YYYY-MM-DD | Initial invariants defined | - |

---

Invariants v1.0.0 - Generated with BMAD Quality Kit
