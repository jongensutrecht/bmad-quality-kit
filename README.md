# BMAD Quality Kit

> **Versie**: 1.0.0
> **Doel**: Waterdichte tests en expliciete succescriteria voor AI-assisted development

---

## Het Probleem

1. Tests zijn groen maar features werken niet
2. AI slaat testsoorten over ("Playwright? Nee, niet gedaan")
3. Geen afdwinging van WELKE tests nodig zijn
4. Geen expliciete documentatie van wat NOOIT mag gebeuren

**Root cause:** Er is geen systeem dat bepaalt welke tests verplicht zijn, afdwingt dat ze bestaan, en expliciet maakt wat niet mag falen.

---

## De Oplossing: 4-Laags Test Quality Systeem

```
LAAG 1: SPECIFICATIE
├── test-requirements.yaml    # Welke tests per path/feature
└── invariants.md             # Wat mag NOOIT gebeuren

LAAG 2: AI GUIDANCE (Skills + Knowledge)
├── /test-guard               # Bepaal en valideer tests
└── /invariant-discovery      # Ontdek invarianten

LAAG 3: ENFORCEMENT (Tools)
├── test-gate.ps1             # Blokkeert als required tests ontbreken
└── invariant-check.ps1       # Blokkeert als invariant zonder test

LAAG 4: CI/CD GATE
└── GitHub Actions / GitLab CI workflows
```

---

## Quick Start

### 1. Installeer in je project

```powershell
# Vanuit bmad-quality-kit directory
pwsh ./INSTALL.ps1 -TargetProject "/path/to/your/project"

# Of met symlinks (voor development)
pwsh ./INSTALL.ps1 -TargetProject "/path/to/your/project" -Symlink
```

### 2. Ontdek invarianten

```bash
# In je project met Claude Code
/invariant-discovery
```

Dit analyseert je codebase en genereert een `invariants.md` bestand met wat NOOIT mag gebeuren.

### 3. Configureer test requirements

Edit `test-requirements.yaml` in je project root:

```yaml
rules:
  - pattern: "components/**"
    required: [unit, playwright]
  - pattern: "api/**"
    required: [unit, integration, contract]
  - pattern: "lib/**"
    required: [unit]
```

### 4. Gebruik test-guard

```bash
# Handmatig
/test-guard

# Of automatisch via CI
pwsh ./tools/test-gate/test-gate.ps1
pwsh ./tools/invariant-check/invariant-check.ps1
```

---

## Structuur

```
bmad-quality-kit/
├── README.md                    # Dit bestand
├── INSTALL.ps1                  # Installer
│
├── templates/                   # Template bestanden
│   ├── test-requirements.yaml   # Test requirements template
│   ├── invariants.md            # Invariants template
│   └── ci/                      # CI/CD templates
│
├── .claude/skills/              # Claude Code skills
│   ├── test-guard/              # Test enforcement skill
│   ├── invariant-discovery/     # Invariant discovery skill
│   ├── bmad-autopilot/          # BMAD workflow
│   ├── cto-guard/               # CTO validation
│   └── ralph-loop/              # Story iteration
│
├── tools/                       # Enforcement tools
│   ├── test-gate/               # Test requirements checker
│   ├── invariant-check/         # Invariant coverage checker
│   └── preflight/               # Story preflight checker
│
├── docs/                        # Documentatie
│   ├── testing/                 # Test filosofie en patterns
│   └── invariants/              # Invariant documentatie
│
├── core/                        # Core regels
│   ├── CORE_RULES.md            # Alle regels samengevoegd
│   └── CONTRACT.md              # Story format contract
│
└── spec/                        # JSON Schemas
    ├── test-requirements.schema.json
    └── invariants.schema.json
```

---

## Workflow

### BMAD Workflow met Testing

```
PROJECT SETUP (eenmalig)
    │
    ▼
1. /invariant-discovery        → invariants.md
    │
    ▼
2. Setup test-requirements.yaml
    │
    ▼
ELKE CODE CHANGE
    │
    ▼
3. /test-guard                 → Check ontbrekende tests
    │
    ▼
4. Gate checks                 → test-gate.ps1 + invariant-check.ps1
    │
    ▼
5. CI/CD                       → Blokkeert PR bij failure
```

### Standalone (zonder BMAD)

```bash
# Bij elke code change
/test-guard

# Of in CI
pwsh tools/test-gate/test-gate.ps1
pwsh tools/invariant-check/invariant-check.ps1
```

---

## Test Types

| Type | Wanneer | Voorbeeld |
|------|---------|-----------|
| `unit` | Pure business logic, geen externe deps | pytest, jest |
| `integration` | Database, API calls, externe services | pytest met fixtures |
| `playwright` | UI flows, browser interactie | @playwright/test |
| `e2e` | Complete user journeys | Cypress, Playwright |
| `contract` | API schema validatie | Dredd, Pact |

---

## Skills

| Skill | Doel | Invocatie |
|-------|------|-----------|
| `/test-guard` | Bepaal en valideer tests | Automatisch of handmatig |
| `/invariant-discovery` | Ontdek invarianten | Bij project setup |
| `/bmad-autopilot` | BMAD story workflow | `/bmad-autopilot` |
| `/cto-guard` | CTO validatie | Automatisch in BMAD |
| `/ralph-loop` | Story iteratie | `/ralph-loop` |

---

## Enforcement Tools

### test-gate.ps1

```powershell
# Check of required tests aanwezig zijn
pwsh tools/test-gate/test-gate.ps1 -RepoRoot .

# Output: exit 0 (OK) of exit 1 (missing tests)
```

### invariant-check.ps1

```powershell
# Check of invarianten test coverage hebben
pwsh tools/invariant-check/invariant-check.ps1 -RepoRoot .

# Output: exit 0 (OK) of exit 1 (uncovered invariants)
```

---

## CI/CD Integration

### GitHub Actions

Kopieer `templates/ci/github-actions/quality-gate.yml` naar `.github/workflows/`:

```yaml
name: Quality Gate
on: [push, pull_request]

jobs:
  quality-gate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Test Gate
        run: pwsh tools/test-gate/test-gate.ps1
      - name: Invariant Check
        run: pwsh tools/invariant-check/invariant-check.ps1
```

---

## Licentie

MIT

---

## Gerelateerde Projecten

- [TDD Guard](https://github.com/nizos/tdd-guard) - TDD enforcement voor Claude Code
- [GitHub Spec-Kit](https://github.com/github/spec-kit) - Executable specifications
- [cc-sdd](https://github.com/gotalab/cc-sdd) - Spec-driven development

---

Quality Kit v1.0.0 - 2026-01-17
