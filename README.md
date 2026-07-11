# Infrastructure as Code (IaC) & DevOps Portfolio
[![Finflow Terraform CI](https://github.com/kamilekbeznosa/IaacProjects/actions/workflows/finflow-ci.yml/badge.svg)](https://github.com/kamilekbeznosa/IaacProjects/actions/workflows/finflow-ci.yml)
[![Kube CI/CD](https://github.com/kamilekbeznosa/IaacProjects/actions/workflows/ci-cd.yml/badge.svg)](https://github.com/kamilekbeznosa/IaacProjects/actions/workflows/ci-cd.yml)

![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)
![Ansible](https://img.shields.io/badge/Ansible-000000?style=for-the-badge&logo=ansible&logoColor=white)
![Azure](https://img.shields.io/badge/Microsoft_Azure-0089D6?style=for-the-badge&logo=microsoft-azure&logoColor=white)
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

---
*This repository is continuously evolving. Upcoming features include GitOps integration (ArgoCD) and the expansion of CI/CD pipelines using Azure DevOps.*
