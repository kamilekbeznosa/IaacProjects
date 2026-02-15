# Azure Virtual Machine Infrastructure with Terraform

This project demonstrates the deployment of a Linux Virtual Machine in Microsoft Azure using Terraform (Infrastructure as Code).

The configuration automates the entire provisioning process, including networking setup, security group configuration, dynamic SSH key generation, and post-deployment application startup using Cloud-Init.

## Architecture Overview

The Terraform code provisions the following resources:

1.  **Resource Group**: A logical container for all resources.
2.  **Networking**:
    * Virtual Network (VNet) and Subnet.
    * Public IP Address (Dynamic).
    * Network Interface (NIC).
3.  **Security (NSG)**:
    * Inbound Rule allowing SSH (Port 22).
    * Inbound Rule allowing HTTP traffic for testing (Port 8080).
4.  **Compute**:
    * Virtual Machine: Ubuntu Server 22.04 LTS.
    * Size: Standard_B1s (burstable, cost-effective).
5.  **Automation**:
    * **SSH Keys**: Automatically generated RSA 4096-bit key pair. The private key is saved locally as `ssh_key.pem`.
    * **Cloud-Init**: A boot script that creates an `index.html` file and starts a simple Python HTTP server on port 8080 for verification.

## Prerequisites

* Terraform v1.0+
* Azure CLI installed and authenticated (`az login`)
* PowerShell or Bash terminal

## Project Structure

* `main.tf`: Contains the resource definitions (VM, Network, NSG, SSH Key).
* `outputs.tf`: Defines the information displayed after deployment (Public IP, SSH command).
* `.gitignore`: Prevents sensitive files (state, keys) from being committed to version control.

## Deployment Guide

### 1. Initialize Terraform

Initialize the working directory to download the required Azure providers.

```bash
terraform init
```

### 2. Review Execution Plan

Check which resources will be created.

```bash
terraform plan
```

### 3. Apply Configuration

Provision the infrastructure in Azure. Type `yes` when prompted.

```bash
terraform apply
```

## Post-Deployment & Connectivity

Upon successful application, Terraform will output the Public IP and the connection command.

### Handling SSH Key Permissions (Windows/PowerShell)

Terraform generates a `ssh_key.pem` file. On Windows, OpenSSH may reject this key if the file permissions are too open (accessible by other users).

If you receive a "WARNING: UNPROTECTED PRIVATE KEY FILE!" error, run the following PowerShell command in the project directory to restrict access to the current user only:

```powershell
$path = ".\ssh_key.pem"
$acl = Get-Acl $path
$acl.SetAccessRuleProtection($true, $false)
$rule = New-Object System.Security.AccessControl.FileSystemAccessRule($env:USERNAME, "Read", "Allow")
$acl.AddAccessRule($rule)
Set-Acl $path $acl
```

### Connecting to the VM

Use the command provided in the Terraform outputs:

```bash
ssh -i ssh_key.pem azureuser@<VM_PUBLIC_IP>
```

## Verification

The VM is configured to start a simple Python HTTP server automatically.

1.  Open your web browser.
2.  Navigate to: `http://<VM_PUBLIC_IP>:8080`
3.  You should see the message: **"Hello from Terraform Automated VM!"** along with the server startup timestamp.



## Infrastructure Cleanup

To remove all resources created by this project and avoid incurring costs, run the destroy command:

```bash
terraform destroy
```

Type `yes` to confirm the deletion of the Resource Group and all associated assets.