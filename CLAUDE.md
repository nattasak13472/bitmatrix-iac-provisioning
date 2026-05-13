# IAC Provisioning: Operations & Execution Guide

## 🚀 Execution Environment
- **Terraform Version:** 1.5.7
- **AWS Provider:** ~> 6.0
- **Primary Region:** `ap-southeast-7` (Thailand)
- **DR Region:** `ap-southeast-1` (Singapore)

## 📂 Multi-Account Strategy
This repository is organized by account and region to strictly isolate the blast radius:
- `nonprod/`: Sandbox, Development, and Staging environments.
- `prod/`: Production-grade infrastructure (High Availability).

## 🛠 Operational Workflows

### 1. Provisioning a Foundation (Tier 1)
Foundation includes VPC, Aurora Global, and ECS Clusters.
- **Dependency:** The Primary region (`ap-southeast-7`) must be applied before the Secondary region (`ap-southeast-1`) to establish the Aurora Global Cluster.
- **Commands:**
```bash
cd infrastructure/nonprod/ap-southeast-7/[folder]
terraform init -backend-config="../../../../_common/backend-config/nonprod-ap-southeast-7.config"
terraform plan -var-file="terraform.tfvars.json"
terraform apply -var-file="terraform.tfvars.json"
```

### 2. Deploying a Microservice (Tier 2)
Services in deployments/ consume infrastructure via SSM Parameter Store.
- Workflow: Ensure the ECR image is pushed before applying.
- Scaling: Adjust task_count or cpu/memory in the service's terraform.tfvars.json to handle the 10k user load.

## 🔑 State Management & Backends
- Isolation: Each leaf folder (e.g., nonprod/ap-southeast-7) has its own backend.tf and S3 state file.
- Naming: Backend keys follow the pattern: [layer]/[account]/[region]/terraform.tfstate.

## 🛡️ Critical Safety Procedures (The "Rules of 10k/20TB")

1. Database Operations (20TB Scale)
- No Direct Destroys: Never run terraform destroy on Aurora folders without manual snapshotting.
- Storage Type: Ensure aurora-iopt8 is selected in variables for production to optimize I/O costs.

2. Disaster Recovery (DR)
- Singapore (ap-southeast-1) is a Warm Standby.
- In failover, the is_primary toggle in prod/ap-southeast-1/terraform.tfvars.json must be updated to promote the secondary cluster.

3. Crypto-Shredding Compliance
- To delete all data for a specific microservice (e.g., auth-service):
    - Identify the specific KMS key ID in the service variables.
    - Schedule the deletion of the KMS Key in the security module.
    - Purge associated S3 buckets and RDS snapshots.

### 💡 Why these details matter for your role:

1.  **Tiered Logic:** By explicitly defining **Tier 1 (Foundation)** and **Tier 2 (Apps)**, you prevent the common mistake of trying to deploy an application before the network or database is ready.
2.  **SSM for Decoupling:** Instead of hardcoding VPC IDs into your microservices, the `CLAUDE.md` reminds developers/AI to use SSM lookups. This makes it possible to migrate to a new VPC in the future without touching 50 microservice repos.
3.  **The "Detailed Exit Code":** For a system with 10,000 users, "Drift" (someone making a manual change in the AWS Console) is your biggest enemy. Adding the health check command to `CLAUDE.md` encourages automated drift detection.
4.  **20TB Safeguards:** At your data scale, a `terraform destroy` is not a 5-minute mistake; it's a multi-day recovery. The safety procedures section acts as a "Big Red Button" warning for the AI and the team.