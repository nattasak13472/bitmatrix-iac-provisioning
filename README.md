# AWS Infrastructure Provisioning

This repository manages the live state of the AWS infrastructure by consuming modules from `iac-modules`. It handles the orchestration of Accounts, Regions, and Microservices.

## 🛠 Tech Stack
- **Terraform Version:** 1.5.7
- **AWS Provider:** ~> 6.0
- **Documentation:** [terraform-docs](https://github.com/terraform-docs/terraform-docs)

## ⚙️ Prerequisites & Local Setup

Before executing any Terraform commands, ensure your local development environment is configured correctly.

### 1. Required Tooling
*   **Terraform:** Install `v1.5.7` (Consider using [tfenv](https://github.com/tfutils/tfenv) for version management: `tfenv install 1.5.7`).
*   **AWS CLI:** Install the latest AWS Command Line Interface (`v2`).
*   **Code Quality Tools:** Install `tflint`, `tfsec`, and `trivy` (required for pre-commit checks).

### 2. AWS Authentication
You must authenticate your local machine with AWS before running Terraform. We highly recommend using AWS SSO (IAM Identity Center) to avoid storing long-lived access keys on your machine.

**Option A: AWS SSO (Recommended)**
1. Run the SSO configuration wizard:
   ```bash
   aws configure sso
   ```
2. Follow the prompts to enter your SSO Start URL and Region.
3. Once configured, log in to retrieve your temporary credentials:
   ```bash
   aws sso login --profile <your-profile-name>
   ```
4. Export the profile for Terraform to use:
   ```bash
   export AWS_PROFILE=<your-profile-name>
   ```

**Option B: Standard IAM Access Keys (Legacy)**
If you are using an IAM User, configure your credentials via the CLI:
```bash
aws configure
```
*(Provide your Access Key ID and Secret Access Key when prompted).*

## Environment Strategy
- **NONPROD:** `ap-southeast-7` (Thailand) - Single instance/Dev/Staging.
- **PROD (Primary):** `ap-southeast-7` (Thailand) - High Availability (3 AZs).
- **PROD (DR):** `ap-southeast-1` (Singapore) - Warm Standby.

## Git Repo Structure
```
.
├── _common/          # TIER 0: Common resources across environments
├── infrastructure/          # TIER 1: Platform Foundation
│   ├── nonprod/
│   │   └── ap-southeast-7/  # Thailand (Dev/Staging)
│   └── prod/
│       ├── ap-southeast-7/  # Thailand (Primary)
│       └── ap-southeast-1/  # Singapore (Warm Standby)
│
└── deployments/             # TIER 2: Application Instances
    ├── nonprod/
    │   ├── ap-southeast-7/
    │   |   ├── order-service/
    │   |   └── auth-service/
    └── prod/
        ├── ap-southeast-7/
        |   ├── order-service/
        |   └── auth-service/
        └── ap-southeast-1/
            ├── order-service/
            └── auth-service/
```

### 0. `_common/` (Common Resources)
Contains common resources that are shared across environments, including:
- `backend-config/`: Partial backend configuration files for different environments and regions.

### 1. `infrastructure/` (The Platform)
Contains the long-lived "Base" resources. Must be applied in this order:
1. `prod/ap-southeast-7`: Creates the Aurora Global Cluster Primary.
2. `prod/ap-southeast-1`: Joins the Secondary cluster to the Global Cluster.

### 2. `deployments/` (The Services)
Contains microservice-specific deployments (Task Definitions & Services). These reference the outputs of the infrastructure layer via SSM Parameter Store.

## ⚙️ Operational Workflow

### Provisioning a Region/Service
```bash
# 1. Navigate to the target leaf folder
cd infrastructure/prod/ap-southeast-7

# 2. Initialize with environment-specific backend config
terraform init -backend-config="../../../../_common/backend-config/nonprod-ap-southeast-7.config"

# 3. Plan and Apply
terraform plan -var-file="terraform.tfvars.json"
terraform apply -var-file="terraform.tfvars.json"
```

## 🔐 Security & Compliance

- KMS: Encryption is mandatory for RDS, S3, and Redis.
- Crypto-Shredding: Managed via per-service KMS keys defined in iac-modules/security.
- Secrets: Use AWS Secrets Manager. Never commit secrets to this repository.

## 📄 Documentation

- See ARCHITECTURE.md for deep-dive resource specifications.
- See CLAUDE.md for AI Agent shortcuts and command references.

---

### 💡 Key Differences in the READMEs:
*   **The Modules README** focuses on **How to build** and **Versioning**.
*   **The Provisioning README** focuses on **Where to deploy** and **Execution order**.

## Common Terraform Commands

| Action | Command |
| :--- | :--- |
| **Initialize** | `terraform init -backend-config="../../../../../_common/backend-config/<env>-<region>.config"` |
| **Plan** | `terraform plan -var-file="terraform.tfvars.json"` |
| **Apply** | `terraform apply -var-file="terraform.tfvars.json"` |
| **Destroy** | `terraform destroy -var-file="terraform.tfvars.json"` |
| **Update Modules** | `terraform get -update` |
| **State Tidy** | `terraform state mv -state-out=terraform.tfstate ../backup/terraform.tfstate.backup` |
