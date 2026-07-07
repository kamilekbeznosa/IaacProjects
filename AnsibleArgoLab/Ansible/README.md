# 🛠️ Automated CI/CD Lab: Jenkins Cluster via Vagrant & Ansible

![Ansible](https://img.shields.io/badge/ansible-%231A1918.svg?style=for-the-badge&logo=ansible&logoColor=white)
![Vagrant](https://img.shields.io/badge/vagrant-%231563FF.svg?style=for-the-badge&logo=vagrant&logoColor=white)
![Jenkins](https://img.shields.io/badge/jenkins-%232C5263.svg?style=for-the-badge&logo=jenkins&logoColor=white)
![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)

## 📌 Project Overview
This project provides a fully automated, reproducible local environment for deploying a **Jenkins Master-Agent architecture**. It utilizes **Vagrant** to provision the underlying Virtual Machines and **Ansible** to perform configuration management, install dependencies, and bootstrap the Jenkins service.

It serves as a practical demonstration of **Infrastructure as Code (IaC)** and **Configuration Management** principles, allowing for the rapid deployment of a CI/CD environment for testing and development purposes.

---

## 🏛 Architecture & Topology

The lab consists of two Virtual Machines running **Ubuntu 22.04 LTS (Jammy)** hosted on VirtualBox, provisioned in a private network loop.

| Node Role | Hostname | IP Address | Specs | OS |
| :--- | :--- | :--- | :--- | :--- |
| **Jenkins Master** | `server-1` | `192.168.56.11` | 1 CPU, 1.5GB RAM | Ubuntu 22.04 |
| **Jenkins Agent** | `server-2` | `192.168.56.12` | 1 CPU, 1.5GB RAM | Ubuntu 22.04 |

---

## ⚙️ Features & Automation Steps

### 1. Infrastructure Provisioning (Vagrant)
*   **Dynamic Node Creation:** The `Vagrantfile` uses a Ruby loop to dynamically define and provision multiple nodes, ensuring scalable infrastructure definition.
*   **Networking:** Configures static IPs within a VirtualBox private network for seamless Master-Agent communication.
*   **SSH Key Management:** Automatically generates and maps SSH private keys for passwordless Ansible access.

### 2. Configuration Management (Ansible)
The `setup.yml` playbook ensures the environment is strictly defined and idempotent. It handles:
*   **Baseline OS Configuration:** Sets the system timezone (`Europe/Warsaw`) and updates APT caches.
*   **Dependency Injection:** Installs fundamental system requirements including `git`, `curl`, `htop`, and `openjdk-17-jre`.
*   **Jenkins Bootstrap (Master Node):** 
    *   Cleans up broken repository lists.
    *   Securely fetches and imports the official Jenkins GPG key.
    *   Adds the Jenkins APT repository and installs the package.
    *   Configures `systemd` to enable and start the Jenkins daemon.
*   **Automated Secrets Retrieval:** Pauses for service initialization, retrieves the `initialAdminPassword` directly from the server, and prints it to the console for immediate use.

---

## 🚀 How to Run the Environment

### Prerequisites
*   [VirtualBox](https://www.virtualbox.org/) installed.
*   [Vagrant](https://www.vagrantup.com/) installed.
*   [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) installed on the host machine.