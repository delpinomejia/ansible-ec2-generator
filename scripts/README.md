# 🛠️ Scripts Directory

This directory contains utility scripts for testing, validating, and managing the Ansible EC2 Generator CI/CD pipeline.

## 📋 Available Scripts

### 🔍 `Validate-CI.ps1` (PowerShell)
**Comprehensive CI/CD pipeline validation script for Windows/PowerShell environments**

#### Purpose
- Validates GitLab CI pipeline configuration without running actual deployments
- Performs syntax checking, security scanning, and dependency validation
- Generates detailed validation reports

#### Features
- ✅ **File Structure Validation** - Ensures all required files are present
- ✅ **YAML Syntax Validation** - Checks GitLab CI and Ansible YAML files
- ✅ **Ansible Syntax Checking** - Validates playbook syntax (if Ansible installed)
- ✅ **Dependency Validation** - Verifies Python requirements.txt
- ✅ **Security Scanning** - Detects hardcoded credentials and security issues
- ✅ **CI Job Structure** - Confirms all required CI jobs are defined
- ⚠️ **Optional Checks** - Ansible lint and dry-run simulation

#### Usage
```powershell
# Basic validation
PowerShell -ExecutionPolicy Bypass -File "scripts\Validate-CI.ps1"

# With verbose output
PowerShell -ExecutionPolicy Bypass -File "scripts\Validate-CI.ps1" -Verbose
```

#### Output
- **Console Output**: Color-coded validation results
- **Log File**: `validation-results.log` in project root
- **Exit Codes**: 0 = Success, 1 = Critical failure

---

### 🔍 `validate-ci.sh` (Bash)
**Comprehensive CI/CD pipeline validation script for Linux/Unix environments**

#### Purpose
Same functionality as PowerShell version but for Linux/Unix systems

#### Usage
```bash
# Make executable
chmod +x scripts/validate-ci.sh

# Run validation
./scripts/validate-ci.sh
```

---

### 🧪 `ci-dry-run.sh` (Bash)
**Simple CI pipeline simulation script**

#### Purpose
- Provides a quick simulation of CI pipeline stages
- Useful for understanding pipeline flow without running actual validations

#### Usage
```bash
# Make executable
chmod +x ci-dry-run.sh

# Run simulation
./ci-dry-run.sh
```

## 🚀 Quick Start

### Windows (PowerShell)
```powershell
# Navigate to project root
cd Z:\Code\ansible-ec2-generator

# Run comprehensive validation
PowerShell -ExecutionPolicy Bypass -File "scripts\Validate-CI.ps1"

# Check results
Get-Content validation-results.log
```

### Linux/Unix (Bash)
```bash
# Navigate to project root
cd /path/to/ansible-ec2-generator

# Make scripts executable
chmod +x scripts/*.sh

# Run comprehensive validation
./scripts/validate-ci.sh

# Check results
cat validation-results.log
```

## 📊 Validation Results

### ✅ Success Indicators
- All required files present
- Valid YAML syntax
- No hardcoded credentials detected
- All CI jobs properly defined
- Dependencies correctly formatted

### ⚠️ Warnings (Non-blocking)
- Tools not installed (yamllint, ansible-playbook)
- Minor YAML formatting issues
- Ansible lint warnings

### ❌ Critical Failures
- Missing required files
- Invalid YAML syntax
- Hardcoded credentials found
- Missing CI job definitions
- Malformed requirements.txt

## 🔧 Dependencies

### Required for Full Validation
```bash
# Install Python tools
pip install -r requirements.txt

# Install system tools (Ubuntu/Debian)
sudo apt-get install yamllint

# Install Ansible
pip install ansible ansible-lint
```

### Optional Tools
- **Docker** - For container image validation
- **AWS CLI** - For AWS-specific validations
- **Git** - For repository checks

## 📝 Validation Report Format

The validation creates a detailed log file with:

```
GitLab CI Pipeline Validation Results
Date: [timestamp]
========================================
[INFO] Starting validations...
[SUCCESS] All required files found
[WARNING] Some tools not installed
[ERROR] Critical issue detected
...
OVERALL RESULT: PASSED/FAILED
```

## 🏗️ CI Integration

These scripts can be integrated into your CI pipeline:

```yaml
# GitLab CI example
validate_local:
  stage: validate
  image: python:3.9-slim
  before_script:
    - apt-get update && apt-get install -y bash
    - pip install -r requirements.txt
  script:
    - chmod +x scripts/validate-ci.sh
    - ./scripts/validate-ci.sh
  artifacts:
    reports:
      junit: validation-results.log
    expire_in: 1 week
```

## 🔍 Troubleshooting

### Common Issues

1. **PowerShell Execution Policy**
   ```powershell
   # Fix with bypass
   PowerShell -ExecutionPolicy Bypass -File script.ps1
   ```

2. **Missing Dependencies**
   ```bash
   # Install required tools
   pip install ansible yamllint ansible-lint
   ```

3. **Permission Issues (Linux)**
   ```bash
   # Make scripts executable
   chmod +x scripts/*.sh
   ```

## 🚀 Future Enhancements

- [ ] **Docker Integration** - Container-based validation
- [ ] **JSON/XML Reports** - Machine-readable output formats
- [ ] **Performance Metrics** - Validation timing and performance
- [ ] **Custom Rules** - Configurable validation rules
- [ ] **Integration Tests** - End-to-end pipeline testing

## 📞 Support

For issues with validation scripts:
1. Check the validation log for detailed error messages
2. Ensure all dependencies are installed
3. Verify file permissions and paths
4. Review the GitLab CI pipeline documentation

---

*These scripts help ensure your CI/CD pipeline is robust, secure, and ready for production deployment! 🎯*
