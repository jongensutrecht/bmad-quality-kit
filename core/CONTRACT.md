# BMAD Story Contract

> Dit contract definieert het verplichte format voor BMAD stories.

---

## Story File Format

Elke story (`OPS-XXX.md`) MOET deze secties bevatten in deze volgorde:

### Verplichte Headers
1. Context
2. Story
3. Test Requirements (v4)
4. Relevante Invariants (v4)
5. Acceptance Criteria (met CTO traceability)
6. Tasks/Subtasks
7. Dev Notes
8. Dev Agent Record
9. Status

---

## Hard Rules

1. **Eerste taak**: Altijd `Lees CLAUDE.md`
2. **Laatste taak**: Altijd `Run Gate A checks`
3. **CTO Traceability**: Elke AC heeft CTO Rule + Facet
4. **Verification**: Elke AC heeft executable command + expected output
5. **Touched Paths**: Expliciete allowlist van bestanden
6. **Test Requirements**: Elke story specificeert welke tests nodig
7. **Invariants**: Relevante invarianten gelinkt aan story

---

## Test Requirements Format (v4)

```markdown
## Test Requirements

| Type | Required | Rationale |
|------|----------|-----------|
| unit | ✅ | Business logic |
| integration | ❌ | Geen externe deps |
| playwright | ✅ | UI flow |
| contract | ❌ | Geen API changes |
```

---

## Relevante Invariants Format (v4)

```markdown
## Relevante Invariants

| ID | Description | NEVER-Test Exists |
|----|-------------|-------------------|
| INV-SEC-001 | [beschrijving] | [ ] |
| INV-BIZ-001 | [beschrijving] | [ ] |
```

---

## AC Format (per Acceptance Criterium)

```markdown
### AC1: [Naam]
- **Given**: [Precondities]
- **When**: [Actie]
- **Then**: [Resultaat]
- **CTO Rule**: `[RULE-ID]`
- **CTO Facet**: `[Facet naam]`
- **Verification (repo-root)**: `[command]`
- **Expected**: `[output/exit]`
```

---

## Tasks Format

```markdown
## Tasks / Subtasks

- [ ] Lees CLAUDE.md
- [ ] [Taak 1]
- [ ] [Taak 2]
- [ ] Schrijf NEVER-tests voor invariants
- [ ] Schrijf required tests (unit/integration/playwright)
- [ ] Run Gate A checks

### Touched paths allowlist
- `path/to/file1`
- `path/to/file2`
```

---

## BACKLOG.md Format

```markdown
# BACKLOG - [Process]

| Story | Title | Status | Attempts | Test Gate | Invariant Check | Notes |
|-------|-------|--------|----------|-----------|-----------------|-------|
| OPS-001 | [title] | [TODO] | 0 | - | - | |
| OPS-002 | [title] | [TODO] | 0 | - | - | |
```

Statussen: `[TODO]`, `[IN_PROGRESS]`, `[DONE]`, `[BLOCKED]`

---

## Gate Columns (v4)

| Column | Values |
|--------|--------|
| Test Gate | ✅, ❌, ⏳, - |
| Invariant Check | ✅, ❌, ⏳, - |

---

## Validation

Stories worden gevalideerd door:

1. **preflight.ps1**: Story format validatie
2. **test-gate.ps1**: Test requirements validatie
3. **invariant-check.ps1**: Invariant coverage validatie
4. **CTO Guard**: CTO rules validatie

---

CONTRACT v2.0.0 - 2026-01-17
