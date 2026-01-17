<#
.SYNOPSIS
    Install BMAD Quality Kit to a target project.

.DESCRIPTION
    This script copies or symlinks the Quality Kit components to a target project:
    - .claude/skills/ - Claude Code skills
    - tools/ - Enforcement tools
    - templates/ - Configuration templates

.PARAMETER TargetProject
    Path to the target project directory.

.PARAMETER Symlink
    Use symlinks instead of copying files. Useful for development.

.PARAMETER SkipSkills
    Skip installing skills.

.PARAMETER SkipTools
    Skip installing tools.

.PARAMETER SkipTemplates
    Skip copying templates.

.PARAMETER Force
    Overwrite existing files without prompting.

.EXAMPLE
    pwsh INSTALL.ps1 -TargetProject /path/to/project

.EXAMPLE
    pwsh INSTALL.ps1 -TargetProject /path/to/project -Symlink

.EXAMPLE
    pwsh INSTALL.ps1 -TargetProject /path/to/project -SkipTemplates
#>

param(
    [Parameter(Mandatory = $true)]
    [string]$TargetProject,

    [switch]$Symlink,
    [switch]$SkipSkills,
    [switch]$SkipTools,
    [switch]$SkipTemplates,
    [switch]$Force
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# ============================================================================
# Helper Functions
# ============================================================================

function Write-Info {
    param([string]$Message)
    Write-Host "[INFO] $Message" -ForegroundColor Cyan
}

function Write-Success {
    param([string]$Message)
    Write-Host "[OK] $Message" -ForegroundColor Green
}

function Write-Warning {
    param([string]$Message)
    Write-Host "[WARN] $Message" -ForegroundColor Yellow
}

function Write-Error {
    param([string]$Message)
    Write-Host "[ERROR] $Message" -ForegroundColor Red
}

function Copy-OrLink {
    param(
        [string]$Source,
        [string]$Target,
        [switch]$UseSymlink
    )

    # Create parent directory if needed
    $parentDir = Split-Path -Parent $Target
    if (-not (Test-Path $parentDir)) {
        New-Item -ItemType Directory -Path $parentDir -Force | Out-Null
    }

    # Check if target exists
    if (Test-Path $Target) {
        if (-not $Force) {
            Write-Warning "Target exists: $Target (use -Force to overwrite)"
            return $false
        }
        Remove-Item -Path $Target -Recurse -Force
    }

    if ($UseSymlink) {
        # Create symlink
        if ($IsWindows) {
            # Windows requires admin for symlinks, use junction for directories
            if (Test-Path $Source -PathType Container) {
                cmd /c mklink /J "$Target" "$Source" | Out-Null
            }
            else {
                cmd /c mklink "$Target" "$Source" | Out-Null
            }
        }
        else {
            # Unix symlink
            ln -s "$Source" "$Target"
        }
        return $true
    }
    else {
        # Copy
        if (Test-Path $Source -PathType Container) {
            Copy-Item -Path $Source -Destination $Target -Recurse -Force
        }
        else {
            Copy-Item -Path $Source -Destination $Target -Force
        }
        return $true
    }
}

# ============================================================================
# Main Logic
# ============================================================================

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "  BMAD Quality Kit Installer              " -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# Resolve paths
$KitRoot = $PSScriptRoot
$TargetProject = (Resolve-Path -LiteralPath $TargetProject -ErrorAction SilentlyContinue)?.Path

if (-not $TargetProject) {
    # Create if doesn't exist
    $TargetProject = $PSBoundParameters['TargetProject']
    if (-not (Test-Path $TargetProject)) {
        Write-Error "Target project does not exist: $TargetProject"
        exit 1
    }
    $TargetProject = (Resolve-Path -LiteralPath $TargetProject).Path
}

Write-Info "Kit Root: $KitRoot"
Write-Info "Target: $TargetProject"
Write-Info "Mode: $(if ($Symlink) { 'Symlink' } else { 'Copy' })"
Write-Host ""

# ============================================================================
# Install Skills
# ============================================================================

if (-not $SkipSkills) {
    Write-Info "Installing skills..."

    $skillsSource = Join-Path $KitRoot ".claude/skills"
    $skillsTarget = Join-Path $TargetProject ".claude/skills"

    # Get list of skills
    $skills = Get-ChildItem -Path $skillsSource -Directory

    foreach ($skill in $skills) {
        $skillSource = $skill.FullName
        $skillTarget = Join-Path $skillsTarget $skill.Name

        $result = Copy-OrLink -Source $skillSource -Target $skillTarget -UseSymlink:$Symlink

        if ($result) {
            Write-Success "  Installed skill: $($skill.Name)"
        }
    }

    Write-Host ""
}

# ============================================================================
# Install Tools
# ============================================================================

if (-not $SkipTools) {
    Write-Info "Installing tools..."

    $toolsSource = Join-Path $KitRoot "tools"
    $toolsTarget = Join-Path $TargetProject "tools"

    # Get list of tools
    $tools = Get-ChildItem -Path $toolsSource -Directory

    foreach ($tool in $tools) {
        $toolSource = $tool.FullName
        $toolTarget = Join-Path $toolsTarget $tool.Name

        $result = Copy-OrLink -Source $toolSource -Target $toolTarget -UseSymlink:$Symlink

        if ($result) {
            Write-Success "  Installed tool: $($tool.Name)"
        }
    }

    Write-Host ""
}

# ============================================================================
# Copy Templates
# ============================================================================

if (-not $SkipTemplates) {
    Write-Info "Copying templates..."

    # Copy test-requirements.yaml if not exists
    $testReqSource = Join-Path $KitRoot "templates/test-requirements.yaml"
    $testReqTarget = Join-Path $TargetProject "test-requirements.yaml"

    if (-not (Test-Path $testReqTarget)) {
        Copy-Item -Path $testReqSource -Destination $testReqTarget
        Write-Success "  Created: test-requirements.yaml"
    }
    else {
        Write-Warning "  Skipped: test-requirements.yaml (already exists)"
    }

    # Copy invariants.md if not exists
    $invSource = Join-Path $KitRoot "templates/invariants.md"
    $invTarget = Join-Path $TargetProject "invariants.md"

    if (-not (Test-Path $invTarget)) {
        Copy-Item -Path $invSource -Destination $invTarget
        Write-Success "  Created: invariants.md"
    }
    else {
        Write-Warning "  Skipped: invariants.md (already exists)"
    }

    # Create test directories if not exist
    $testDirs = @(
        "tests/invariants/auth",
        "tests/invariants/security",
        "tests/invariants/business",
        "tests/invariants/performance",
        "tests/invariants/reliability",
        "tests/unit",
        "tests/integration",
        "tests/e2e"
    )

    foreach ($dir in $testDirs) {
        $dirPath = Join-Path $TargetProject $dir
        if (-not (Test-Path $dirPath)) {
            New-Item -ItemType Directory -Path $dirPath -Force | Out-Null
            Write-Success "  Created: $dir/"
        }
    }

    Write-Host ""
}

# ============================================================================
# Summary
# ============================================================================

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "  Installation Complete                   " -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host ""
Write-Host "1. Run invariant discovery:"
Write-Host "   /invariant-discovery"
Write-Host ""
Write-Host "2. Configure test requirements:"
Write-Host "   Edit test-requirements.yaml"
Write-Host ""
Write-Host "3. Test the installation:"
Write-Host "   pwsh tools/test-gate/test-gate.ps1 -RepoRoot . -DryRun"
Write-Host "   pwsh tools/invariant-check/invariant-check.ps1 -RepoRoot . -DryRun"
Write-Host ""
Write-Host "4. Add to CI/CD:"
Write-Host "   Copy templates/ci/github-actions/quality-gate.yml to .github/workflows/"
Write-Host ""

exit 0
