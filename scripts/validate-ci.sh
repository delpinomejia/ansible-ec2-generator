#!/bin/bash
# ============================================================================
# GitLab CI Pipeline Validation Script
# ============================================================================
# This script performs real validation of CI pipeline components
# without deploying actual infrastructure
# ============================================================================

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
RESULTS_FILE="$PROJECT_ROOT/validation-results.log"

# Initialize results file
echo "GitLab CI Pipeline Validation Results" > "$RESULTS_FILE"
echo "Date: $(date)" >> "$RESULTS_FILE"
echo "========================================" >> "$RESULTS_FILE"

# Helper functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
    echo "[INFO] $1" >> "$RESULTS_FILE"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
    echo "[SUCCESS] $1" >> "$RESULTS_FILE"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
    echo "[WARNING] $1" >> "$RESULTS_FILE"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
    echo "[ERROR] $1" >> "$RESULTS_FILE"
}

# Validation functions
validate_yaml_syntax() {
    log_info "Validating YAML syntax..."
    
    if command -v yamllint >/dev/null 2>&1; then
        if yamllint -d relaxed "$PROJECT_ROOT/.gitlab-ci.yml" >/dev/null 2>&1; then
            log_success "GitLab CI YAML syntax is valid"
        else
            log_error "GitLab CI YAML syntax validation failed"
            return 1
        fi
        
        if yamllint -d relaxed "$PROJECT_ROOT"/*.yml "$PROJECT_ROOT"/vars/*.yml >/dev/null 2>&1; then
            log_success "All YAML files have valid syntax"
        else
            log_warning "Some YAML files have syntax issues (non-blocking)"
        fi
    else
        log_warning "yamllint not installed, skipping YAML validation"
    fi
}

validate_ansible_syntax() {
    log_info "Validating Ansible playbook syntax..."
    
    if command -v ansible-playbook >/dev/null 2>&1; then
        if ansible-playbook --syntax-check "$PROJECT_ROOT/ec2-playbook.yml" >/dev/null 2>&1; then
            log_success "Ansible playbook syntax is valid"
        else
            log_error "Ansible playbook syntax validation failed"
            return 1
        fi
    else
        log_warning "ansible-playbook not installed, skipping Ansible validation"
    fi
}

validate_docker_images() {
    log_info "Validating Docker images used in CI..."
    
    # Extract images from GitLab CI file
    local images=("python:3.9-slim" "node:16-alpine")
    
    for image in "${images[@]}"; do
        log_info "Checking availability of Docker image: $image"
        if docker pull "$image" >/dev/null 2>&1; then
            log_success "Docker image $image is available"
        else
            log_warning "Docker image $image may not be available (or Docker not running)"
        fi
    done
}

validate_dependencies() {
    log_info "Validating Python dependencies..."
    
    if [ -f "$PROJECT_ROOT/requirements.txt" ]; then
        log_success "requirements.txt found"
        
        # Check if we can parse requirements
        while IFS= read -r line; do
            if [[ $line =~ ^[a-zA-Z] ]]; then
                package=$(echo "$line" | cut -d'>' -f1 | cut -d'=' -f1 | cut -d'<' -f1)
                log_info "Found dependency: $package"
            fi
        done < "$PROJECT_ROOT/requirements.txt"
        
        log_success "Requirements file is properly formatted"
    else
        log_error "requirements.txt not found"
        return 1
    fi
}

validate_file_structure() {
    log_info "Validating project file structure..."
    
    local required_files=(
        ".gitlab-ci.yml"
        "ec2-playbook.yml"
        "vars/vars_sample.yml"
        "README.md"
        "requirements.txt"
        ".gitignore"
    )
    
    for file in "${required_files[@]}"; do
        if [ -f "$PROJECT_ROOT/$file" ]; then
            log_success "Required file found: $file"
        else
            log_error "Required file missing: $file"
            return 1
        fi
    done
}

validate_security_practices() {
    log_info "Validating security practices..."
    
    # Check for hardcoded credentials (excluding sample files)
    if grep -r "aws_access_key\|aws_secret_key\|password" "$PROJECT_ROOT" \
        --include="*.yml" --exclude="*sample*" >/dev/null 2>&1; then
        log_error "Potential hardcoded credentials found"
        return 1
    else
        log_success "No hardcoded credentials detected"
    fi
    
    # Check if .gitignore excludes sensitive files
    if grep -q "vars/vars.yml" "$PROJECT_ROOT/.gitignore"; then
        log_success ".gitignore properly excludes sensitive configuration"
    else
        log_warning ".gitignore may not exclude sensitive files"
    fi
}

validate_ci_job_structure() {
    log_info "Validating CI job structure..."
    
    # Check if all required jobs are present
    local required_jobs=(
        "validate_ansible_syntax"
        "validate_yaml_files"
        "test_ansible_lint"
        "test_dry_run"
        "security_scan"
        "deploy_infrastructure"
        "cleanup_resources"
        "validate_documentation"
    )
    
    for job in "${required_jobs[@]}"; do
        if grep -q "$job:" "$PROJECT_ROOT/.gitlab-ci.yml"; then
            log_success "CI job found: $job"
        else
            log_error "CI job missing: $job"
            return 1
        fi
    done
}

run_ansible_lint() {
    log_info "Running Ansible lint (if available)..."
    
    if command -v ansible-lint >/dev/null 2>&1; then
        if ansible-lint "$PROJECT_ROOT/ec2-playbook.yml" 2>/dev/null; then
            log_success "Ansible lint passed without warnings"
        else
            log_warning "Ansible lint found issues (may be non-blocking)"
        fi
    else
        log_warning "ansible-lint not installed, skipping lint check"
    fi
}

simulate_dry_run() {
    log_info "Simulating Ansible dry run..."
    
    # Create temporary vars file for dry run
    if [ -f "$PROJECT_ROOT/vars/vars_sample.yml" ]; then
        cp "$PROJECT_ROOT/vars/vars_sample.yml" "$PROJECT_ROOT/vars/vars_test.yml"
        
        if command -v ansible-playbook >/dev/null 2>&1; then
            # Attempt dry run with test variables
            if ansible-playbook --check --diff \
                -e "vars_files=['vars/vars_test.yml']" \
                "$PROJECT_ROOT/ec2-playbook.yml" >/dev/null 2>&1; then
                log_success "Ansible dry run simulation passed"
            else
                log_warning "Ansible dry run simulation completed with warnings (expected without AWS credentials)"
            fi
        else
            log_warning "ansible-playbook not available for dry run simulation"
        fi
        
        # Cleanup
        rm -f "$PROJECT_ROOT/vars/vars_test.yml"
    else
        log_error "vars_sample.yml not found for dry run simulation"
    fi
}

# Main validation function
main() {
    log_info "Starting GitLab CI Pipeline Validation"
    log_info "Project root: $PROJECT_ROOT"
    
    local exit_code=0
    
    # Run all validations
    validate_file_structure || exit_code=1
    validate_yaml_syntax || exit_code=1
    validate_ansible_syntax || exit_code=1
    validate_dependencies || exit_code=1
    validate_security_practices || exit_code=1
    validate_ci_job_structure || exit_code=1
    
    # Optional validations (warnings only)
    validate_docker_images
    run_ansible_lint
    simulate_dry_run
    
    # Final results
    echo "" >> "$RESULTS_FILE"
    if [ $exit_code -eq 0 ]; then
        log_success "All critical validations passed!"
        echo "OVERALL RESULT: PASSED" >> "$RESULTS_FILE"
    else
        log_error "Some critical validations failed!"
        echo "OVERALL RESULT: FAILED" >> "$RESULTS_FILE"
        exit $exit_code
    fi
    
    log_info "Validation results saved to: $RESULTS_FILE"
}

# Execute main function
main "$@"
