# ☁️ Finflow - Enterprise Azure & Kubernetes DevOps Infrastructure

![Architecture Diagram](diagram.png) ## 📖 Project Overview
Finflow is a comprehensive cloud infrastructure project based on the **Infrastructure as Code (IaC)** approach. It simulates a secure, scalable enterprise environment for a financial application. 

The main goal of the project is to completely isolate internal tools (such as monitoring systems) from the public internet using a **Point-to-Site VPN**, while securely exposing traffic for client applications through an **Application Gateway (L7)** paired with **AGIC** (Application Gateway Ingress Controller).

## 🛠️ Tech Stack
* **Cloud Provider:** Microsoft Azure
* **Infrastructure as Code:** Terraform
* **Orchestration:** Azure Kubernetes Service (AKS)
* **Networking & Security:** Azure VNet, P2S VPN Gateway, Application Gateway (WAF ready), Azure Private Endpoints
* **Package Management:** Helm
* **Observability:** Grafana (Internal Load Balancer)
* **Scripting:** PowerShell / Bash

## ✨ Key Architecture Features
1. **Secure Internal Access:** Access to resources within the cluster (e.g., Grafana) is restricted exclusively to authorized personnel connected via P2S VPN (`172.16.200.0/24`). The *Azure Internal Load Balancer* annotation was utilized to prevent public IP exposure.
2. **L7 Ingress Routing:** Implemented Application Gateway with the AGIC controller. This enables direct traffic routing to Kubernetes pods, eliminating extra network hops and allowing for efficient SSL termination.
3. **Network Isolation:** The environment is strictly segmented into dedicated subnets (AKS, AGW, Data, Private Endpoints, GatewaySubnet) to accommodate future, granular Network Security Group (NSG) rules.
4. **Idempotent Automation:** Post-deployment configurations and application bootstrapping are fully automated using idempotent PowerShell scripts.

## 📂 Project Structure
```text
├── Modules/
│   ├── acr/           # Azure Container Registry
│   ├── agw/           # Application Gateway
│   ├── Aks/           # Azure Kubernetes Service & Node Pools
│   ├── database/      # PaaS Database (e.g., PostgreSQL)
│   ├── keyvault/      # Azure Key Vault for secrets
│   ├── Networking/    # VNet, Subnets & Delegation
│   ├── redis/         # Redis Cache via Private Endpoint
│   └── vpn/           # Virtual Network Gateway (P2S VPN)
├── main.tf            # Main Terraform configuration & module calls
├── variables.tf       # Global variables declaration
├── terraform.tfvars   # Variable values (CIDR blocks, env vars)
├── grafana-values.yaml# Helm values for internal Grafana deployment
└── setup-cluster.ps1  # Post-deployment automation script
```

## 🚀 How to Run the Project

### 1. Prerequisites
* [Terraform](https://www.terraform.io/downloads.html) installed locally.
* [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) (authenticated via `az login`).
* `kubectl` and `helm` CLIs installed.
* Self-Signed certificates (Root & Client) generated locally for P2S VPN authentication.

### 2. Infrastructure Deployment
Initialize and provision the infrastructure using Terraform:
```bash
terraform init
terraform plan
terraform apply -auto-approve
```
*Note: Provisioning the Virtual Network Gateway in Azure typically takes 30-45 minutes.*

### 3. Connect to VPN
1. Download the VPN client configuration from the Azure Portal (Virtual Network Gateways -> Point-to-site configuration -> Download VPN client).
2. Install the profile for your OS and connect to the network.
3. Verify the connection:
```bash
ipconfig # Look for the PPP adapter with an IP from the 172.16.200.x range
```

### 4. Application Deployment (Post-Deployment Script)
Execute the automation script to connect to the AKS cluster and install internal tools:
```powershell
.\automationsetup.ps1
```
The script will automatically fetch AKS credentials, install Grafana (using the `grafana-values.yaml` overrides), wait for the internal IP allocation, and decrypt the admin password.

### 5. Verification
Confirm that the Grafana service has received a private IP address in the `EXTERNAL-IP` column (e.g., `10.0.2.x`):
```bash
kubectl get svc moja-grafana
```
Navigate to the retrieved IP address in your web browser while the VPN connection is active.

## 🧹 Cleanup
To prevent unwanted cloud usage costs, always destroy the resources after you finish your session:
```bash
terraform destroy -auto-approve
```

## 🗺️ Roadmap / Future Improvements
* [ ] **Load Testing & Autoscaling:** Implement Autocannon/K6 tools to generate traffic and configure the Horizontal Pod Autoscaler (HPA) to demonstrate dynamic scaling.
* [ ] **GitOps:** Deprecate imperative deployment scripts in favor of declarative state management using **ArgoCD**.
* [ ] **CI/CD Pipeline:** Build end-to-end workflows in **GitHub Actions** for automated container image building and testing.
* [ ] **Configuration Management:** Integrate **Ansible** for post-provisioning configuration of external Virtual Machines (e.g., Bastion hosts).
