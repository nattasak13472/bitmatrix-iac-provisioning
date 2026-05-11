# AWS Client VPN Deployment

This folder manages the AWS Client VPN Endpoint for the `nonprod` environment. It uses Google SSO (SAML) for authentication and is integrated with Route53 for a friendly DNS name.

## 🚀 Deployment Order (Critical)

Since this stack is decoupled from DNS management, you must follow this exact sequence:

### Phase 1: DNS & Certificate
1.  Navigate to `dns/base` and ensure the Hosted Zone for your root domain exists.
2.  Navigate to `dns/vpn`.
3.  Run `terraform apply` to request the ACM certificate.
4.  **Manual Step**: Wait for the DNS validation to complete in the AWS Console. The certificate status must be **Issued**.
5.  Copy the **Certificate ARN** from the outputs.

### Phase 2: VPN Endpoint
1.  Navigate to this folder (`vpn`).
2.  Update `terraform.tfvars.json`:
    *   Paste the **Certificate ARN** into `client_vpn_server_cert_arn`.
3.  Run `terraform apply`.
4.  Copy the **VPN Endpoint DNS Name** from the outputs.

### Phase 3: Friendly DNS Name (CNAME)
1.  Navigate back to `dns/vpn`.
2.  Update `terraform.tfvars.json`:
    *   Paste the **VPN Endpoint DNS Name** into `vpn_endpoint_dns_name`.
3.  Run `terraform apply` again to create the CNAME record (`vpn.nonprod.bitmatrix.com`).

---

## 🔐 Authentication
This VPN uses **Google SSO** (SAML 2.0). 

In `terraform.tfvars.json`, you will see two SAML-related variables. Usually, you should set **both to the same ARN**:

*   **`saml_provider_arn`**: Used by the desktop VPN Client app to authenticate users when they connect.
*   **`self_service_saml_provider_arn`**: Used for the web-based self-service portal where users download their own config files.

*   Ensure the `saml_provider_arn` in `terraform.tfvars.json` is correct.
*   The SAML App in Google must be configured with the correct Metadata XML imported into AWS IAM.

## 📂 Configuration Files
*   `backend.tf`: S3 bucket configuration for state management.
*   `main.tf`: Calls the `iac-modules/networking/vpn` module.
*   `terraform.tfvars.json`: Contains environment-specific values (VPC IDs, CIDRs, ARNs).

## 🛠 Common Commands
```bash
# Initialize with backend config
terraform init -backend-config="../../../../../_common/backend-config/nonprod-ap-southeast-7.config"

# Plan changes
terraform plan

# Apply changes
terraform apply
```
