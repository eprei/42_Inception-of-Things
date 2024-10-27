# Inception of Things (IoT)

A comprehensive infrastructure project focused on Kubernetes deployment and management using K3s, K3d, and Argo CD for continuous delivery.

## 🎯 Overview

This project implements a multi-part infrastructure setup demonstrating advanced cloud-native development and DevOps practices. It covers cluster setup, application deployment, and GitOps workflows using modern container orchestration tools.

## 🛠️ Technologies

- **Kubernetes**: K3s (lightweight K8s distribution)
- **Container Management**: K3d
- **GitOps**: Argo CD
- **Infrastructure as Code**: Vagrant
- **Containerization**: Docker
- **Configuration Management**: YAML, Shell Scripts
- **Ingress Controller**: NGINX

## 🏗️ Project Structure

The project is divided into three main parts:

### Part 1: K3s and Vagrant
- Multi-node cluster setup with Server and ServerWorker nodes
- Automated deployment using Vagrant
- Network configuration with dedicated IPs
- K3s installation in controller and agent modes

### Part 2: K3s and Application Deployment
- Deployment of three web applications
- Ingress configuration with host-based routing
- Load balancing with multiple replicas
- NGINX Ingress Controller implementation

### Part 3: K3d and Argo CD
- K3d cluster setup
- Argo CD deployment and configuration
- GitOps workflow implementation
- Continuous deployment pipeline
- Application version management

## 🚀 Setup and Installation

1. Clone the repository

2. Navigate to desired part
```bash
cd p1 # or p2 or p3
```

3. Start the infrastructure
```bash
# For Part 1 & 2
vagrant up

# For Part 3
./scripts/init.sh
```

## 📚 Key Learning Outcomes

- Kubernetes cluster management and orchestration
- GitOps principles and implementation
- Infrastructure as Code practices
- Continuous Deployment workflows
- Container orchestration and management
- Ingress traffic management
- Cloud-native application deployment

## 💡 Features

- Automated infrastructure provisioning
- Multi-node cluster architecture
- GitOps-based deployment pipeline
- Host-based routing
- Load balancing and high availability
- SSL/TLS certificate management
- Automated application updates

## 🔍 Project Details

### Cluster Configuration
- Server Node: 192.168.56.110
- ServerWorker Node: 192.168.56.111
- K3s in controller/agent mode
- Automated setup with Vagrant

### Application Deployment
- Three web applications with different configurations
- Host-based routing (app1.com, app2.com)
- Default routing for undefined hosts
- Multiple replicas for high availability

### GitOps Implementation
- Argo CD for continuous deployment
- Git repository as single source of truth
- Automated synchronization
- Version management and rollbacks

## 📋 Prerequisites

- VirtualBox
- Vagrant
- kubectl
- Docker
- Git

## 🎓 Acknowledgments

This project was completed as part of the 42 School curriculum, focusing on DevOps and cloud-native development practices.
