# Getting Started

This guide walks you through setting up the BMAD Quality Kit in your project.

## Prerequisites

- PowerShell 7+ (pwsh)
- Git
- Claude Code CLI (for skills)

## Installation

### Option 1: Copy to Project

```powershell
cd /path/to/bmad-quality-kit
pwsh INSTALL.ps1 -TargetProject /path/to/your/project
```

This copies:
- `.claude/skills/` - All skills
- `templates/` - Template files
- `tools/` - Enforcement tools

### Option 2: Symlink (Development)

```powershell
pwsh INSTALL.ps1 -TargetProject /path/to/your/project -Symlink
```

Creates symlinks so updates to the kit are immediately available.

## Initial Setup

### Step 1: Discover Invariants

```bash
# In your project with Claude Code
/invariant-discovery
```

This will:
1. Analyze your codebase
2. Ask questions about security, business rules, performance
3. Generate `invariants.md`

### Step 2: Configure Test Requirements

Copy and edit the template:

```bash
cp templates/test-requirements.yaml ./test-requirements.yaml
```

Edit to match your project structure:

```yaml
rules:
  - pattern: "src/components/**"
    required: [unit, playwright]

  - pattern: "src/api/**"
    required: [unit, integration, contract]

  - pattern: "src/utils/**"
    required: [unit]
```

### Step 3: Create Test Directory Structure

```bash
mkdir -p tests/invariants/{auth,security,business,performance,reliability}
mkdir -p tests/unit
mkdir -p tests/integration
mkdir -p tests/e2e
```

### Step 4: Run Initial Checks

```powershell
# Check test requirements
pwsh tools/test-gate/test-gate.ps1 -RepoRoot . -DryRun

# Check invariant coverage
pwsh tools/invariant-check/invariant-check.ps1 -RepoRoot . -DryRun
```

## Daily Workflow

### Before Marking Code as "Done"

```bash
# In Claude Code
/test-guard
```

This will:
1. Check which tests are required
2. Verify they exist
3. Check invariant coverage
4. Report missing tests

### For BMAD Story Development

```bash
# Start BMAD autopilot
/bmad-autopilot

# Or iterate over existing stories
/ralph-loop
```

## CI/CD Integration

Copy the workflow to your project:

```bash
# GitHub Actions
cp templates/ci/github-actions/quality-gate.yml .github/workflows/

# GitLab CI
cp templates/ci/gitlab-ci/quality-gate.yml .gitlab-ci.yml
```

## Verification

### Test the Setup

1. Make a change to a file that requires tests
2. Run test-gate:
   ```powershell
   pwsh tools/test-gate/test-gate.ps1 -RepoRoot .
   ```
3. It should report the missing test

### Verify Skills Work

```bash
# In Claude Code
/test-guard
```

Should show the test guard workflow.

## Troubleshooting

### "test-requirements.yaml not found"

Create the file from template:
```bash
cp templates/test-requirements.yaml ./
```

### "invariants.md not found"

Run discovery:
```bash
/invariant-discovery
```

### Skills not loading

Ensure `.claude/skills/` directory exists with SKILL.md files:
```bash
ls -la .claude/skills/
```

## Next Steps

1. Read [Testing Philosophy](testing/philosophy.md)
2. Understand [Invariants](invariants/what-are-invariants.md)
3. Learn [BMAD Workflow](bmad/overview.md)
