# Ansible Configuration Management & Hardening

[![Ansible CI](https://github.com/kamilekbeznosa/IaacProjects/actions/workflows/ansible-ci.yaml/badge.svg)](https://github.com/kamilekbeznosa/IaacProjects/actions/workflows/ansible-ci.yaml)
![Ansible](https://img.shields.io/badge/Ansible-EE0000?style=flat&logo=ansible&logoColor=white)
![Ubuntu](https://img.shields.io/badge/Ubuntu-22.04-orange)

A production-style **Configuration Management** lab demonstrating how to provision, harden, and deploy workloads on Linux VMs using **Ansible roles**, **Jinja2 templates**, **environment-specific inventories**, and **Ansible Vault** for secrets.

This project covers the full stack from OS hardening through application deployment, reverse proxy, and observability agent installation — ready to target Azure VMs provisioned via Terraform (Finflow) or any Ubuntu host reachable over SSH.

Part of the [IaacProjects](https://github.com/kamilekbeznosa/IaacProjects) DevOps portfolio.

---

## Table of Contents

- [Architecture](#architecture)
- [Roles](#roles)
- [Directory Structure](#directory-structure)
- [Environments](#environments)
- [Secrets Management](#secrets-management)
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [CI/CD](#cicd)
- [What I Learned](#what-i-learned)
- [Skills Demonstrated](#skills-demonstrated)

---

## Architecture

```text
                    ┌─────────────────────────────────────────┐
                    │           Internet / Client             │
                    └──────────────────┬──────────────────────┘
                                       │ :80
                              ┌────────▼────────┐
                              │  nginx (role)   │  ← Jinja2 reverse_proxy.conf.j2
                              │  Reverse Proxy  │
                              └────────┬────────┘
                                       │ localhost:8080
                              ┌────────▼────────┐
                              │   app (role)    │  ← Docker container (internal port)
                              └─────────────────┘

  ┌──────────────────────────────────────────────────────────────┐
  │  common (role): UFW · fail2ban · unattended-upgrades · SSH   │
  │  node_exporter (role): Prometheus metrics on :9100 (systemd)  │
  └──────────────────────────────────────────────────────────────┘
```

**Execution flow:** `site.yml` applies all four roles to every host in the selected inventory — hardening first, then application stack, proxy, and monitoring agent.

---

## Roles

| Role | Purpose | Key tasks |
|---|---|---|
| **`common`** | OS hardening baseline (Ubuntu) | UFW default-deny + allow 22/80/443, disable SSH password auth & root login, install `fail2ban` and `unattended-upgrades` |
| **`app`** | Application runtime | Install Docker CE, deploy containerized app bound to an **internal port** (not exposed publicly) |
| **`nginx`** | Reverse proxy | Jinja2 template generates vhost config; exposes app on port 80 using `domain_name` and `app_internal_port` from inventory vars |
| **`node_exporter`** | Observability | Dedicated system user, Prometheus Node Exporter binary, `systemd` service — host ready for scraping by the [Observability Platform](../GitOps/README.md) |

Each role follows the **Ansible Galaxy standard layout**: `tasks/`, `handlers/`, `defaults/`, `vars/`, `meta/`, and role-level tests.

---

## Directory Structure

```text
ansible-lab/
├── ansible.cfg                 # defaults: inventory, roles_path, vault_password_file
├── playbooks/
│   └── site.yml                # master playbook — applies all roles
├── inventories/
│   ├── dev/
│   │   ├── hosts.ini
│   │   └── group_vars/all.yaml # dev-specific: domain_name, app_internal_port
│   └── prod/
│       └── hosts.ini
├── group_vars/
│   └── all.yaml                # shared variables across environments
└── roles/
    ├── common/
    ├── app/
    ├── nginx/
    │   └── templates/
    │       └── reverse_proxy.conf.j2
    └── node_exporter/
```

**Design principle:** logic lives in **roles**, environment differences live in **inventories / group_vars** — no hardcoded values in task files.

---

## Environments

Environments are fully isolated through separate inventories:

| Environment | Inventory path | Example overrides |
|---|---|---|
| **DEV** | `inventories/dev/` | `domain_name: dev.local`, `app_internal_port: 8080` |
| **PROD** | `inventories/prod/` | production domain, stricter vars (extend as needed) |

Switch environments by changing the `-i` flag — the same `site.yml` drives both.

---

## Secrets Management

Sensitive values are encrypted with **Ansible Vault**.

| File | Purpose |
|---|---|
| `.vault_pass` | Local vault password file — **gitignored**, never committed |
| `ansible.cfg` | References `vault_password_file = .vault_pass` |

```bash
# Encrypt a secrets file
ansible-vault encrypt group_vars/all/vault.yaml

# Edit encrypted file
ansible-vault edit group_vars/all/vault.yaml
```

> Public repository rule: only encrypted vault blobs or `example` templates in Git. Plaintext credentials never touch the remote.

---

## Prerequisites

- **Ansible** ≥ 2.14 (`pip install ansible`)
- **ansible-lint** (optional locally; enforced in CI)
- Target host(s): Ubuntu VM with SSH access and sudo privileges
- Local file `.vault_pass` containing your vault password (create manually)

---

## Quick Start

### 1. Configure inventory

Edit `inventories/dev/hosts.ini` with your VM IP or hostname:

```ini
[webservers]
dev-vm ansible_host=10.0.1.4 ansible_user=azureuser
```

Adjust `inventories/dev/group_vars/all.yaml` if needed:

```yaml
app_internal_port: 8080
domain_name: dev.local
```

### 2. Create vault password file

```bash
echo "your-vault-password" > .vault_pass
chmod 600 .vault_pass
```

### 3. Run syntax check

```bash
cd ansible-lab
ansible-playbook --syntax-check playbooks/site.yml
```

### 4. Apply configuration (DEV)

```bash
ansible-playbook -i inventories/dev/hosts.ini playbooks/site.yml
```

### 5. Apply configuration (PROD)

```bash
ansible-playbook -i inventories/prod/hosts.ini playbooks/site.yml
```

### Useful flags

```bash
# Check mode — dry run, no changes applied
ansible-playbook -i inventories/dev/hosts.ini playbooks/site.yml --check

# Limit to a single role
ansible-playbook -i inventories/dev/hosts.ini playbooks/site.yml --tags common

# Verbose output for debugging
ansible-playbook -i inventories/dev/hosts.ini playbooks/site.yml -vvv
```

---

## CI/CD

GitHub Actions workflow [`.github/workflows/ansible-ci.yaml`](../.github/workflows/ansible-ci.yaml) runs on every push/PR affecting `ansible-lab/`:

1. Install `ansible` + `ansible-lint`
2. Create a dummy `.vault_pass` for CI (no real secrets)
3. **`ansible-playbook --syntax-check`** on `playbooks/site.yml`

Extend locally with:

```bash
ansible-lint playbooks/site.yml
ansible-playbook --syntax-check playbooks/site.yml
```

---

## What I Learned

| Challenge | Solution | Takeaway |
|---|---|---|
| Environment drift | Separate inventories + `group_vars` per env | Configuration data must not live inside role tasks |
| Exposing app safely | Docker on internal port + Nginx reverse proxy | Only the proxy faces the network; app stays on localhost |
| Dynamic Nginx config | Jinja2 template driven by `domain_name` / `app_internal_port` | Templates make roles reusable across environments |
| SSH attack surface | UFW deny-by-default, disable password & root login | Hardening is a role, not a one-time manual step |
| Metrics collection | Node Exporter as dedicated `systemd` user | Observability starts at the VM layer, not only in Kubernetes |
| Secrets in public repos | Ansible Vault + `.vault_pass` in `.gitignore` | IaC repos can be public if secrets are encrypted or externalized |

---

## Skills Demonstrated

Portfolio / CV bullet points:

- Built **reusable Ansible roles** (Linux hardening, Dockerized app deployment, Nginx reverse proxy with **Jinja2 templates**, Prometheus Node Exporter) with **dev/prod inventories** and **group_vars**.
- Applied **Ansible Vault** for secrets management; integrated **ansible-lint** and syntax-check validation in **GitHub Actions CI**.
- Connected VM-level observability (**node_exporter**) with the Kubernetes **Observability Platform** (Prometheus/Grafana) in the same portfolio.

**Technologies:** Ansible, Jinja2, Ubuntu, Docker, Nginx, Prometheus Node Exporter, UFW, fail2ban, Ansible Vault, GitHub Actions

---

## Related Projects

| Project | Connection |
|---|---|
| [Finflow (Terraform)](../Project/README.md) | Provisions Azure VMs / networking — Ansible configures what Terraform creates |
| [Observability Platform (GitOps)](../GitOps/README.md) | Prometheus scrapes `node_exporter` metrics from these hosts |
| [AnsibleArgoLab (Jenkins)](../AnsibleArgoLab/Ansible/README.md) | Earlier local Vagrant + Ansible CI/CD lab — this project is the production-style evolution |

---

## License

MIT — same as the parent repository.
