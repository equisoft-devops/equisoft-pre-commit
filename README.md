# pre-commit-tfsort

A collection of pre-commit hooks for Terraform/OpenTofu projects, featuring automated sorting and security validation.


## 🔧 tfsort Integration

### What is tfsort?

[tfsort](https://github.com/AlexNabokikh/tfsort) is a CLI tool that sorts Terraform/Opentofu configuration files to ensure consistent ordering of variables, outputs, and other blocks.

### Prerequisites

- [pre-commit](https://pre-commit.com/) installed
- [tfsort](https://github.com/AlexNabokikh/tfsort) installed

### Installing tfsort

```bash
# Using Go
go install github.com/AlexNabokikh/tfsort@latest

# Using Homebrew (macOS/Linux)
brew install tfsort

# Using npm
npm install -g tfsort
```

### tfsort Hook Configuration

Add to your `.pre-commit-config.yaml`:

```yaml
repos:
  - repo: https://github.com/equisoft-devops/equisoft-pre-commit
    rev: v2
    hooks:
      - id: tfsort
```

### What the tfsort hook does

**Files matched**: `variables.tf`, `outputs.tf`, `versions.tf`

**Functionality**:
- Sorts variable declarations alphabetically
- Sorts output declarations alphabetically
- Sorts provider and terraform blocks in versions files
- Maintains proper Terraform syntax and formatting

**Example**:
```hcl
# Before
variable "environment" {
  description = "Environment name"
  type        = string
}

variable "app_name" {
  description = "Application name"
  type        = string
}

# After (sorted alphabetically)
variable "app_name" {
  description = "Application name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}
```

### tfsort Configuration Options

```yaml
repos:
  - repo: https://github.com/mcantin/pre-commit-tfsort
    rev: v1.0.0
    hooks:
      - id: tfsort
        files: ^(variables|outputs|versions|locals)\.tf$  # Include locals.tf, par default only variables, outputs, and versions
        exclude: ^modules/legacy/  # Skip legacy modules
```

## 🔐 SOPS + KMS Integration

### What is SOPS?

[SOPS](https://github.com/mozilla/sops) (Secrets OPerationS) is an editor for encrypted files that supports AWS KMS, GCP KMS, Azure Key Vault, and PGP.

### SOPS Hook Configuration

Add to your `.pre-commit-config.yaml`:

```yaml
repos:
  - repo: https://github.com/mcantin/pre-commit-tfsort
    rev: v2
    hooks:
      - id: kms-check
```

### What the KMS check hook does

**Files matched**: Files ending with `/secrets.yaml`

**Functionality**:
- Validates that encrypted files contain a KMS role ARN
- Ensures the KMS key matches the environment directory structure
- Prevents accidentally using wrong KMS keys across environments
