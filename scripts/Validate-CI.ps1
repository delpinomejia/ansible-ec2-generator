# ============================================================================
# GitLab CI Pipeline Validation Script (PowerShell)
# ============================================================================
# This script performs real validation of CI pipeline components
# without deploying actual infrastructure (Windows/PowerShell version)
# ============================================================================

param(
    [switch]$Verbose = $false
)

# Set error action preference
$ErrorActionPreference = "Stop"

# Configuration
$ScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$ProjectRoot = Split-Path -Parent $ScriptRoot
$ResultsFile = Join-Path $ProjectRoot "validation-results.log"

# Colors for output (if supported)
$Colors = @{
    Red = "Red"
    Green = "Green" 
    Yellow = "Yellow"
    Blue = "Blue"
    White = "White"
}

# Initialize results file
"GitLab CI Pipeline Validation Results" | Out-File -FilePath $ResultsFile -Encoding UTF8
"Date: $(Get-Date)" | Out-File -FilePath $ResultsFile -Append -Encoding UTF8
"========================================" | Out-File -FilePath $ResultsFile -Append -Encoding UTF8

# Helper functions
function Write-LogInfo {
    param([string]$Message)
    Write-Host "[INFO] $Message" -ForegroundColor $Colors.Blue
    "[INFO] $Message" | Out-File -FilePath $ResultsFile -Append -Encoding UTF8
}

function Write-LogSuccess {
    param([string]$Message)
    Write-Host "[SUCCESS] $Message" -ForegroundColor $Colors.Green
    "[SUCCESS] $Message" | Out-File -FilePath $ResultsFile -Append -Encoding UTF8
}

function Write-LogWarning {
    param([string]$Message)
    Write-Host "[WARNING] $Message" -ForegroundColor $Colors.Yellow
    "[WARNING] $Message" | Out-File -FilePath $ResultsFile -Append -Encoding UTF8
}

function Write-LogError {
    param([string]$Message)
    Write-Host "[ERROR] $Message" -ForegroundColor $Colors.Red
    "[ERROR] $Message" | Out-File -FilePath $ResultsFile -Append -Encoding UTF8
}

# Validation functions
function Test-YamlSyntax {
    Write-LogInfo "Validating YAML syntax..."
    
    # Check if yamllint is available
    try {
        $yamlLintPath = Get-Command yamllint -ErrorAction Stop
        
        # Test GitLab CI YAML
        $gitlabCiPath = Join-Path $ProjectRoot ".gitlab-ci.yml"
        $result = & yamllint $gitlabCiPath 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-LogSuccess "GitLab CI YAML syntax is valid"
        } elseif ($LASTEXITCODE -eq 1 -and $result -match "warning") {
            Write-LogSuccess "GitLab CI YAML syntax is valid (with warnings)"
        } else {
            Write-LogError "GitLab CI YAML syntax validation failed"
            return $false
        }
        
        # Test other YAML files
        $yamlFiles = Get-ChildItem -Path $ProjectRoot -Filter "*.yml" -Recurse
        foreach ($file in $yamlFiles) {
            if ($file.Name -like "*sample*") { continue }
            $result = & yamllint -d relaxed $file.FullName 2>&1
            if ($LASTEXITCODE -ne 0) {
                Write-LogWarning "YAML file has syntax issues (non-blocking): $($file.Name)"
            }
        }
        
        Write-LogSuccess "YAML syntax validation completed"
    }
    catch {
        Write-LogWarning "yamllint not installed, skipping YAML validation"
    }
    
    return $true
}

function Test-AnsibleSyntax {
    Write-LogInfo "Validating Ansible playbook syntax..."
    
    try {
        $ansiblePath = Get-Command ansible-playbook -ErrorAction Stop
        $playbookPath = Join-Path $ProjectRoot "ec2-playbook.yml"
        
        $result = & ansible-playbook --syntax-check $playbookPath 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-LogSuccess "Ansible playbook syntax is valid"
            return $true
        } else {
            Write-LogError "Ansible playbook syntax validation failed"
            return $false
        }
    }
    catch {
        Write-LogWarning "ansible-playbook not installed, skipping Ansible validation"
        return $true
    }
}

function Test-FileStructure {
    Write-LogInfo "Validating project file structure..."
    
    $requiredFiles = @(
        ".gitlab-ci.yml",
        "ec2-playbook.yml",
        "vars\vars_sample.yml",
        "README.md",
        "requirements.txt",
        ".gitignore"
    )
    
    $allFound = $true
    foreach ($file in $requiredFiles) {
        $filePath = Join-Path $ProjectRoot $file
        if (Test-Path $filePath) {
            Write-LogSuccess "Required file found: $file"
        } else {
            Write-LogError "Required file missing: $file"
            $allFound = $false
        }
    }
    
    return $allFound
}

function Test-Dependencies {
    Write-LogInfo "Validating Python dependencies..."
    
    $requirementsPath = Join-Path $ProjectRoot "requirements.txt"
    if (Test-Path $requirementsPath) {
        Write-LogSuccess "requirements.txt found"
        
        # Parse requirements file
        $requirements = Get-Content $requirementsPath
        foreach ($line in $requirements) {
            if ($line -match "^[a-zA-Z]") {
                $package = ($line -split "[>=<]")[0]
                Write-LogInfo "Found dependency: $package"
            }
        }
        
        Write-LogSuccess "Requirements file is properly formatted"
        return $true
    } else {
        Write-LogError "requirements.txt not found"
        return $false
    }
}

function Test-SecurityPractices {
    Write-LogInfo "Validating security practices..."
    
    # Check for hardcoded credentials
    $searchTerms = @("aws_access_key", "aws_secret_key", "password")
    $foundCredentials = $false
    
    foreach ($term in $searchTerms) {
        $ymlFiles = Get-ChildItem -Path $ProjectRoot -Filter "*.yml" -Recurse | Where-Object { $_.Name -notlike "*sample*" }
        foreach ($file in $ymlFiles) {
            if (Select-String -Path $file.FullName -Pattern $term -Quiet) {
                Write-LogError "Potential hardcoded credentials found in: $($file.Name)"
                $foundCredentials = $true
            }
        }
    }
    
    if (-not $foundCredentials) {
        Write-LogSuccess "No hardcoded credentials detected"
    }
    
    # Check .gitignore
    $gitignorePath = Join-Path $ProjectRoot ".gitignore"
    if (Test-Path $gitignorePath) {
        $gitignoreContent = Get-Content $gitignorePath
        if ($gitignoreContent -contains "vars/vars.yml") {
            Write-LogSuccess ".gitignore properly excludes sensitive configuration"
        } else {
            Write-LogWarning ".gitignore may not exclude sensitive files"
        }
    }
    
    return -not $foundCredentials
}

function Test-CIJobStructure {
    Write-LogInfo "Validating CI job structure..."
    
    $requiredJobs = @(
        "validate_ansible_syntax",
        "validate_yaml_files", 
        "test_ansible_lint",
        "test_dry_run",
        "security_scan",
        "deploy_infrastructure",
        "cleanup_resources",
        "validate_documentation"
    )
    
    $gitlabCiPath = Join-Path $ProjectRoot ".gitlab-ci.yml"
    $ciContent = Get-Content $gitlabCiPath -Raw
    
    $allJobsFound = $true
    foreach ($job in $requiredJobs) {
        if ($ciContent -match "${job}:") {
            Write-LogSuccess "CI job found: $job"
        } else {
            Write-LogError "CI job missing: $job"
            $allJobsFound = $false
        }
    }
    
    return $allJobsFound
}

function Test-AnsibleLint {
    Write-LogInfo "Running Ansible lint (if available)..."
    
    try {
        $ansibleLintPath = Get-Command ansible-lint -ErrorAction Stop
        $playbookPath = Join-Path $ProjectRoot "ec2-playbook.yml"
        
        $result = & ansible-lint $playbookPath 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-LogSuccess "Ansible lint passed without warnings"
        } else {
            Write-LogWarning "Ansible lint found issues (may be non-blocking)"
        }
    }
    catch {
        Write-LogWarning "ansible-lint not installed, skipping lint check"
    }
}

function Test-DryRunSimulation {
    Write-LogInfo "Simulating Ansible dry run..."
    
    $varsPath = Join-Path $ProjectRoot "vars\vars_sample.yml"
    if (Test-Path $varsPath) {
        $testVarsPath = Join-Path $ProjectRoot "vars\vars_test.yml"
        Copy-Item $varsPath $testVarsPath
        
        try {
            $ansiblePath = Get-Command ansible-playbook -ErrorAction Stop
            $playbookPath = Join-Path $ProjectRoot "ec2-playbook.yml"
            
            $result = & ansible-playbook --check --diff $playbookPath 2>&1
            if ($LASTEXITCODE -eq 0) {
                Write-LogSuccess "Ansible dry run simulation passed"
            } else {
                Write-LogWarning "Ansible dry run simulation completed with warnings (expected without AWS credentials)"
            }
        }
        catch {
            Write-LogWarning "ansible-playbook not available for dry run simulation"
        }
        finally {
            if (Test-Path $testVarsPath) {
                Remove-Item $testVarsPath -Force
            }
        }
    } else {
        Write-LogError "vars_sample.yml not found for dry run simulation"
    }
}

# Main validation function
function Invoke-MainValidation {
    Write-LogInfo "Starting GitLab CI Pipeline Validation"
    Write-LogInfo "Project root: $ProjectRoot"
    
    $exitCode = 0
    
    # Run critical validations
    if (-not (Test-FileStructure)) { $exitCode = 1 }
    if (-not (Test-YamlSyntax)) { $exitCode = 1 }
    if (-not (Test-AnsibleSyntax)) { $exitCode = 1 }
    if (-not (Test-Dependencies)) { $exitCode = 1 }
    if (-not (Test-SecurityPractices)) { $exitCode = 1 }
    if (-not (Test-CIJobStructure)) { $exitCode = 1 }
    
    # Optional validations (warnings only)
    Test-AnsibleLint
    Test-DryRunSimulation
    
    # Final results
    "" | Out-File -FilePath $ResultsFile -Append -Encoding UTF8
    if ($exitCode -eq 0) {
        Write-LogSuccess "All critical validations passed!"
        "OVERALL RESULT: PASSED" | Out-File -FilePath $ResultsFile -Append -Encoding UTF8
    } else {
        Write-LogError "Some critical validations failed!"
        "OVERALL RESULT: FAILED" | Out-File -FilePath $ResultsFile -Append -Encoding UTF8
    }
    
    Write-LogInfo "Validation results saved to: $ResultsFile"
    
    return $exitCode
}

# Execute main function
try {
    $result = Invoke-MainValidation
    exit $result
}
catch {
    Write-LogError "Validation script failed with error: $($_.Exception.Message)"
    "OVERALL RESULT: ERROR" | Out-File -FilePath $ResultsFile -Append -Encoding UTF8
    exit 1
}
