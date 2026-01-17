# Story Format

## Template

```markdown
# [STORY_ID]: [Title]

## Context
[Background and motivation]

## Story
**Als** [role]
**Wil ik** [capability]
**Zodat** [benefit]

## Test Requirements

| Type | Required | Rationale |
|------|----------|-----------|
| unit | ✅ | [reason] |
| integration | ❌ | [reason] |
| playwright | ✅ | [reason] |
| contract | ❌ | [reason] |

## Relevante Invariants

| ID | Description | NEVER-Test Exists |
|----|-------------|-------------------|
| INV-SEC-001 | [description] | [ ] |
| INV-BIZ-001 | [description] | [ ] |

## Acceptance Criteria

### AC1: [Name]
- **Given**: [precondition]
- **When**: [action]
- **Then**: [result]
- **CTO Rule**: `[RULE-ID]`
- **CTO Facet**: `[Facet name]`
- **Verification (repo-root)**: `[command]`
- **Expected**: `[output]`

## Tasks / Subtasks

- [ ] Lees CLAUDE.md
- [ ] [Task 1]
- [ ] [Task 2]
- [ ] Schrijf NEVER-tests voor invariants
- [ ] Schrijf required tests
- [ ] Run Gate A checks

### Touched paths allowlist
- `path/to/file1`
- `path/to/file2`

## Dev Notes
[Technical notes]

## Dev Agent Record
| Timestamp | Agent | Action | Result |
|-----------|-------|--------|--------|

## Status
**ready-for-dev**
```

## Required Sections

### Context

Background information explaining why this story exists.

### Story

User story format:
- **Als** (As a) - role/persona
- **Wil ik** (I want) - capability
- **Zodat** (So that) - business value

### Test Requirements (v4)

Table specifying which test types are required:

| Type | Description |
|------|-------------|
| unit | Isolated function/class tests |
| integration | Database/API tests |
| playwright | Browser/E2E tests |
| contract | API schema tests |

### Relevante Invariants (v4)

Links to invariants from `invariants.md` that apply to this story.

### Acceptance Criteria

Each AC must have:
- Given/When/Then
- CTO Rule reference
- CTO Facet (category)
- Verification command
- Expected output

### Tasks / Subtasks

Always starts with:
```
- [ ] Lees CLAUDE.md
```

Always ends with:
```
- [ ] Run Gate A checks
```

New in v4:
```
- [ ] Schrijf NEVER-tests voor invariants
- [ ] Schrijf required tests
```

### Touched Paths Allowlist

Explicit list of files this story may modify.

### Dev Notes

Technical implementation notes.

### Dev Agent Record

Log of agent actions during execution.

### Status

One of:
- `drafted` - Not ready for execution
- `ready-for-dev` - Ready for execution

## Verification Format

```markdown
- **Verification (repo-root)**: `pytest tests/unit/test_feature.py -v`
- **Expected**: `exit 0`
```

Or with custom working directory:
```markdown
- **Verification (cwd=frontend/)**: `npm test`
- **Expected**: `exit 0`
```

## Example Story

```markdown
# OPS-001: Implement User Authentication

## Context
Users need to authenticate before accessing protected resources.

## Story
**Als** een eindgebruiker
**Wil ik** kunnen inloggen met email en wachtwoord
**Zodat** ik toegang krijg tot mijn account

## Test Requirements

| Type | Required | Rationale |
|------|----------|-----------|
| unit | ✅ | Auth logic |
| integration | ✅ | Database/token storage |
| playwright | ✅ | Login flow UI |
| contract | ❌ | No external API |

## Relevante Invariants

| ID | Description | NEVER-Test Exists |
|----|-------------|-------------------|
| INV-SEC-001 | Auth required for protected endpoints | [ ] |
| INV-SEC-002 | User data never exposed to others | [ ] |

## Acceptance Criteria

### AC1: Successful Login
- **Given**: A registered user with valid credentials
- **When**: User submits login form with correct email and password
- **Then**: User receives JWT token and is redirected to dashboard
- **CTO Rule**: `SEC-001`
- **CTO Facet**: `Security`
- **Verification (repo-root)**: `pytest tests/integration/test_auth.py::test_login_success -v`
- **Expected**: `exit 0`

### AC2: Failed Login
- **Given**: An unregistered email or wrong password
- **When**: User submits login form
- **Then**: User sees error message, no token issued
- **CTO Rule**: `SEC-002`
- **CTO Facet**: `Security`
- **Verification (repo-root)**: `pytest tests/integration/test_auth.py::test_login_failure -v`
- **Expected**: `exit 0`

## Tasks / Subtasks

- [ ] Lees CLAUDE.md
- [ ] Create User model with password hashing
- [ ] Implement login endpoint
- [ ] Add JWT token generation
- [ ] Create login form component
- [ ] Schrijf NEVER-tests voor INV-SEC-001, INV-SEC-002
- [ ] Schrijf unit tests
- [ ] Schrijf integration tests
- [ ] Schrijf playwright tests
- [ ] Run Gate A checks

### Touched paths allowlist
- `src/models/user.py`
- `src/api/auth.py`
- `src/components/LoginForm.tsx`
- `tests/unit/test_user.py`
- `tests/integration/test_auth.py`
- `tests/e2e/login.spec.ts`
- `tests/invariants/auth/test_never_auth_bypass.py`

## Dev Notes
- Use bcrypt for password hashing
- JWT tokens expire after 24 hours
- Refresh tokens not in scope

## Dev Agent Record
| Timestamp | Agent | Action | Result |

## Status
**ready-for-dev**
```
