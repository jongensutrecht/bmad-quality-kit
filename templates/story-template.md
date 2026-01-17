# [STORY_ID]: [Story Title]

## Context

[Beschrijf de context en achtergrond van deze story]

## Story

**Als** [rol]
**Wil ik** [functionaliteit]
**Zodat** [business waarde]

## Test Requirements

> Welke testsoorten zijn verplicht voor deze story?

| Type | Required | Rationale |
|------|----------|-----------|
| unit | [ ] | Business logic |
| integration | [ ] | Externe dependencies |
| e2e/playwright | [ ] | UI flow |
| contract | [ ] | API changes |

## Relevante Invariants

> Welke invarianten zijn relevant voor deze story?

| Invariant ID | Description | Test Exists |
|--------------|-------------|-------------|
| INV-SEC-001 | [beschrijving] | [ ] |
| INV-BIZ-001 | [beschrijving] | [ ] |

## Acceptance Criteria

### AC1: [Criterium naam]
- **Given**: [Precondities]
- **When**: [Actie]
- **Then**: [Resultaat]
- **CTO Rule**: `[RULE-ID]`
- **CTO Facet**: `[Facet naam]`
- **Verification (repo-root)**: `[command]`
- **Expected**: `[output/exit]`

### AC2: [Criterium naam]
- **Given**: [Precondities]
- **When**: [Actie]
- **Then**: [Resultaat]
- **CTO Rule**: `[RULE-ID]`
- **CTO Facet**: `[Facet naam]`
- **Verification (repo-root)**: `[command]`
- **Expected**: `[output/exit]`

## Tasks / Subtasks

- [ ] Lees CLAUDE.md
- [ ] [Taak 1]
- [ ] [Taak 2]
- [ ] [Taak 3]
- [ ] Schrijf NEVER-tests voor relevante invarianten
- [ ] Schrijf required tests (unit/integration/playwright)
- [ ] Run Gate A checks

### Touched paths allowlist

- `[path/to/file1]`
- `[path/to/file2]`

## Dev Notes

[Technische notities voor de developer]

## Dev Agent Record

| Timestamp | Agent | Action | Result |
|-----------|-------|--------|--------|
| | | | |

## Status

**ready-for-dev**

---

Template v1.0.0 - BMAD Quality Kit
