# IAM SAML Provider for VPN

This folder manages the trust relationship between AWS and Google Workspace for Client VPN authentication.

## 📋 Prerequisites (Google Admin Console)

Before running `terraform apply`, you must set up the SAML application in Google Workspace to obtain the required Metadata XML.

### 1. Create the SAML App in Google
1.  Log in to the [Google Admin Console](https://admin.google.com/).
2.  Go to **Apps** > **Web and mobile apps**.
3.  Click **Add app** > **Add custom SAML app**.
4.  **App Details**: Name it `AWS Client VPN (Nonprod)`.
5.  **Google IdP Information**: Click **DOWNLOAD METADATA**. 
    *   Save this file as `GoogleIDPMetadata.xml`.
    *   Place it in the `files/` directory in this folder.
6.  **Service Provider Details**: 
    *   **ACS URL**: `https://self-service.clientvpn.amazonaws.com/api/auth/sso/saml` (Standard for AWS Client VPN).
    *   **Entity ID**: `urn:amazon:webservices:clientvpn` (Standard for AWS Client VPN).
    *   **Name ID format**: `EMAIL`.
    *   **Name ID element**: `Primary email`.

### 2. Attribute Mapping
Ensure you map the following attributes so AWS can identify the users:
*   `NameID` -> `Primary Email`
*   *(Optional but recommended)* `memberOf` -> `Employee Details > Department` (if you want to restrict access by groups later).

### 3. Enable for Users
Make sure to set the **User access** to **ON for everyone** (or specific organizational units) in Google Admin.

---

## 🚀 Deployment

1.  Place the downloaded `GoogleIDPMetadata.xml` into the `files/` directory.
2.  Initialize and apply:
    ```bash
    terraform init -backend-config="../../../../../_common/backend-config/nonprod-ap-southeast-7.config"
    terraform apply
    ```
3.  Copy the `saml_provider_arn` from the output and use it in your `vpn/terraform.tfvars.json`.

---

## ⚠️ Security Note
The `files/GoogleIDPMetadata.xml` contains your public SSO configuration. While it doesn't contain passwords, it should be treated as sensitive configuration. Ensure this repository remains private.
