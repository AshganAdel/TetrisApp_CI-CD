#   Full Deployment    

# 🟪🟪🟪 Tetris Game CI/CD & GitOps Deployment on AWS EKS

## Overview

This project demonstrates a complete end-to-end DevOps platform using:

* GitHub
* Jenkins
* GitHub Actions
* Terraform (Custom Modules)
* Ansible
* SonarQube
* OWASP Dependency Check
* Docker
* Amazon ECR
* Amazon EKS
* ArgoCD
* Redis
* Kubernetes

The platform automates:

* Infrastructure provisioning
* CI/CD pipeline execution
* Security scanning
* Code quality validation
* Docker image build & push
* GitOps-based Kubernetes deployments
* Monitoring of test and coverage reports

The architecture follows GitOps and Infrastructure as Code (IaC) practices for scalability, automation, and consistency.

---

# Architecture
[![CI/CD Architecture](https://drive.google.com/uc?export=view&id=1XkvzML7RFgPQAY3yKgDshVIERBpVEyqq)](https://drive.google.com/file/d/1XkvzML7RFgPQAY3yKgDshVIERBpVEyqq/view)

## High-Level Workflow

1. Developers push code to GitHub.
2. GitHub webhook triggers Jenkins pipeline.
3. Jenkins pipeline:

   * Installs dependencies
   * Runs OWASP dependency scanning
   * Executes unit tests
   * Generates npm coverage reports
   * Runs SonarQube analysis & quality gates
   * Builds Docker image
   * Pushes image to Amazon ECR
   * Updates Kubernetes manifests
   * Publishes reports in Jenkins
4. ArgoCD detects manifest changes.
5. ArgoCD deploys application updates to Amazon EKS.
6. Users access the application through ELB + Kubernetes Ingress.

Infrastructure provisioning is fully automated using Terraform custom modules and configured using Ansible.

---

# Project Structure

```bash
.
├── app-repo/                  # Application source code
├── infra-repo/                # Terraform + Ansible infrastructure code
├── k8s-repo/                  # Kubernetes manifests
├── Jenkinsfile                # Jenkins CI/CD pipeline
├── terraform/
│   ├── modules/
│   │   ├── vpc/
│   │   ├── eks/
│   │   ├── ec2/
│   │   ├── ecr/
│   │   └── iam/
│   └── environments/
├── ansible/
│   ├── playbooks/
│   ├── roles/
│   └── inventory/
└── README.md
```

---

# Infrastructure Architecture
![Architecture Diagram](https://drive.google.com/uc?export=view&id=1HKmOLXlfygEcMnTrHGCBOmLEUaT1gc0H)

## AWS Services Used

* Amazon VPC
* Amazon EC2
* Amazon EKS
* Amazon ECR
* Elastic Load Balancer (ELB)
* IAM
* Route Tables
* Security Groups

---

## VPC Design

The infrastructure is deployed inside a custom VPC containing:

| Subnet           | Type    | Purpose              |
| ---------------- | ------- | -------------------- |
| Public Subnet    | Public  | Jenkins EC2 Instance |
| Private Subnet 1 | Private | EKS Worker Node      |
| Private Subnet 2 | Private | EKS Worker Node      |
| Private Subnet 3 | Private | EKS Worker Node      |

---

## EKS Cluster

The Kubernetes cluster contains:

* 3 worker nodes
* One node deployed in each private subnet
* Application workloads
* Redis deployment
* ArgoCD deployment
* Ingress Controller

---

# Terraform Infrastructure Provisioning

Infrastructure provisioning is implemented using reusable Terraform custom modules.

## Terraform Modules

### VPC Module

Creates:

* VPC
* Public subnet
* 3 private subnets
* Internet Gateway
* Route tables
* NAT Gateway

### EC2 Module

Creates:

* Jenkins EC2 instance
* Security groups
* SSH access

### ECR Module

Creates:

* Amazon ECR repositories

### EKS Module

Creates:

* EKS cluster
* Managed node groups
* IAM roles
* Kubernetes networking

### IAM Module

Creates:

* IAM roles
* Policies
* Service accounts

---

# GitHub Actions for Infrastructure

The `infra-repo` contains a GitHub Actions workflow responsible for provisioning and configuring infrastructure.

## GitHub Actions Workflow

The workflow performs:

1. Checkout infrastructure code
2. Terraform Init
3. Terraform Plan
4. Terraform Apply
5. Run Ansible Playbooks

---

# Ansible Configuration

After infrastructure provisioning, Ansible configures the environment automatically.

## Ansible Responsibilities

### Jenkins EC2 Configuration

* Install Jenkins
* Install Java
* Install Docker
* Install kubectl
* Install AWS CLI
* Install ArgoCD CLI
* Configure Jenkins plugins

### Kubernetes Configuration

* Install ArgoCD in EKS
* Configure namespaces
* Configure ingress
* Configure Redis deployment
* Configure application deployments

### Networking & Security

* Configure ELB
* Configure Security Groups
* Configure IAM permissions

---

# Jenkins CI/CD Pipeline

The Jenkins pipeline runs on an EC2 instance located in the public subnet.

## Pipeline Stages

### 1. Checkout Source Code

Jenkins pulls source code from GitHub.

### 2. Install Dependencies

Example:

```bash
npm install
```

### 3. OWASP Dependency Check

Scans dependencies for known vulnerabilities.

### 4. Unit Testing

Example:

```bash
npm test
```

### 5. Code Coverage

Generates npm coverage reports.

Example:

```bash
npm run coverage
```

### 6. SonarQube Analysis

Runs:

* Static code analysis
* Coverage analysis
* Quality Gate validation

### 7. Build Docker Image

Example:

```bash
docker build -t app-image .
```

### 8. Push Docker Image to Amazon ECR

Example:

```bash
docker push <ecr-image>
```

### 9. Update Kubernetes Manifests

Updates image tags inside Kubernetes deployment manifests.

### 10. Publish Reports

Reports published in Jenkins:

* Test reports
* Coverage reports
* OWASP reports
* SonarQube reports

---

# GitOps Deployment with ArgoCD

ArgoCD continuously monitors the Kubernetes manifests repository.

## Workflow

1. Jenkins updates Kubernetes manifests.
2. Changes are pushed to `k8s-repo`.
3. ArgoCD detects updates automatically.
4. ArgoCD syncs manifests.
5. Updated workloads are deployed to EKS.

---

# Redis Deployment

Redis is deployed inside the EKS cluster.

## Redis Usage

Redis is used for:

* Caching
* Session storage
* Performance optimization

The Redis deployment runs across the EKS environment for high availability.

---

# Application Access Flow

Users access the application using:

```text
Users → ELB → Kubernetes Ingress → Application Service → Pods
```

---

# Security & Quality Controls

## Security

* OWASP Dependency Check
* IAM least privilege access
* Private EKS worker nodes
* Kubernetes RBAC
* Security Groups

## Quality

* SonarQube Quality Gates
* Unit Testing
* Coverage validation
* Automated CI/CD checks

---

# Tools & Technologies

| Category                 | Technologies            |
| ------------------------ | ----------------------- |
| CI/CD                    | Jenkins, GitHub Actions |
| IaC                      | Terraform               |
| Configuration Management | Ansible                 |
| Containers               | Docker                  |
| Orchestration            | Kubernetes, EKS         |
| GitOps                   | ArgoCD                  |
| Registry                 | Amazon ECR              |
| Cloud                    | AWS                     |
| Security                 | OWASP Dependency Check  |
| Code Quality             | SonarQube               |
| Cache                    | Redis                   |

---

# Deployment Flow Summary

```text
Developer Push → GitHub → Jenkins Pipeline → Security & Quality Checks
→ Docker Build → Amazon ECR → Update K8s Manifests
→ ArgoCD Sync → Amazon EKS Deployment → ELB → Users
```

---

# Future Improvements

Potential future enhancements:

* Prometheus & Grafana monitoring
* Helm charts
* Blue/Green deployments
* Canary deployments
* Kubernetes autoscaling
* Secrets management with Vault
* Service mesh integration
* Multi-environment deployments

---

# Learning Objectives

This project demonstrates:

* CI/CD implementation
* GitOps workflows
* Kubernetes deployments
* AWS cloud infrastructure
* Infrastructure as Code
* Configuration management
* Security scanning
* Automated deployments
* Cloud-native DevOps practices

---
