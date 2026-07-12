# Infrastructure as Code (IaC) & DevOps Portfolio
[![Finflow Terraform CI](https://github.com/kamilekbeznosa/IaacProjects/actions/workflows/finflow-ci.yml/badge.svg)](https://github.com/kamilekbeznosa/IaacProjects/actions/workflows/finflow-ci.yml)
[![Kube CI/CD](https://github.com/kamilekbeznosa/IaacProjects/actions/workflows/ci-cd.yml/badge.svg)](https://github.com/kamilekbeznosa/IaacProjects/actions/workflows/ci-cd.yml)
[![Ansible CI](https://github.com/kamilekbeznosa/IaacProjects/actions/workflows/ansible-ci.yaml/badge.svg)](https://github.com/kamilekbeznosa/IaacProjects/actions/workflows/ansible-ci.yaml)
[![AWS Terraform CI](https://github.com/kamilekbeznosa/IaacProjects/actions/workflows/aws-terraform-ci.yml/badge.svg)](https://github.com/kamilekbeznosa/IaacProjects/actions/workflows/aws-terraform-ci.yml)


![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)
![Ansible](https://img.shields.io/badge/Ansible-000000?style=for-the-badge&logo=ansible&logoColor=white)
![Azure](https://img.shields.io/badge/Microsoft_Azure-0089D6?style=for-the-badge&logo=microsoft-azure&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-Cloud-232F3E?logo=amazon-aws&logoColor=white)
![Kubernetes](https://img.shields.io/badge/Kubernetes-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white)

## 📖 Repository Overview
This repository serves as a comprehensive collection of practical projects focused on **DevOps, Cloud Engineering, and infrastructure automation**. It was created to demonstrate hands-on experience in designing, deploying, and managing modern IT environments utilizing **Infrastructure as Code (IaC)** and **Configuration Management** principles.

The featured projects range from foundational cloud deployments to advanced distributed architectures in Microsoft Azure (including Kubernetes clusters and Zero-Trust private networking), as well as fully automated local CI/CD environments.

---

## 📂 Project Structure

Click on the project name in the table below to navigate to the detailed documentation and source code.

| Project | Architectural Overview | Key Technologies |
| :--- | :--- | :--- |
| **[1. Finflow: Secure Cloud Infrastructure](Project/README.md)** | An advanced IaC project deploying a highly secure (Zero-Trust) microservices architecture on Azure. Features AKS configuration, Application Gateway with WAF, and databases isolated via Private Endpoints. | Terraform, Azure, Kubernetes, Docker |
| **[2. Automated CI/CD Lab: Jenkins Cluster](AnsibleArgoLab/Ansible/README.md)** | A fully automated, local Master-Agent CI/CD environment. Demonstrates the use of Vagrant for dynamic machine provisioning and Ansible for hands-free system configuration and bootstrapping. | Ansible, Vagrant, Jenkins, Linux |
| **[3. Azure VM Basics](01VMBasics/README.md)** | A foundational IaC project demonstrating the basics of infrastructure provisioning, remote state management, and strict network configuration (VNet, NSG) in the Azure cloud. | Terraform, Azure |
| **[4. GitOps: Observability Platform](GitOps/README.md)** | A complete Cloud-Native monitoring pipeline deployed via ArgoCD (app-of-apps). Features a custom .NET API with native telemetry, centralized log aggregation (Loki/Alloy), metrics visualization (Prometheus/Grafana), and automated incident alerting. | Kubernetes, ArgoCD, Prometheus, Grafana, Loki |
| **[5. Ansible Configuration Management & Hardening](ansible-lab/README.md)** | Production-style configuration management with reusable Ansible roles: Ubuntu hardening (UFW, fail2ban, SSH), Dockerized app deployment, Nginx reverse proxy via Jinja2 templates, and Prometheus Node Exporter. Separate dev/prod inventories, Ansible Vault for secrets, and CI syntax-check via GitHub Actions. | Ansible, Jinja2, Docker, Nginx, Node Exporter, Linux |
| **[6. AWS Multi-Tier Infrastructure & Serverless Automation](aws-terraform-lab/README.md)** | Production-ready AWS stack in Terraform: VPC (multi-AZ), EC2 behind Application Load Balancer with Nginx bootstrap, S3 static assets, Python Lambda cost reporter on EventBridge schedule, IAM least privilege, and encrypted remote state (S3 + DynamoDB locking). CI with TFLint, validate, and Checkov. Includes Azure→AWS architecture mapping. | Terraform, AWS, VPC, EC2, ALB, S3, Lambda, EventBridge, Python, Checkov |

---
*Six end-to-end projects covering Azure, AWS, Kubernetes, Ansible, GitOps, and Python automation — continuously maintained as part of my DevOps portfolio.*
