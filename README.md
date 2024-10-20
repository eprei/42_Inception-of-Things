# Inception-of-Things (IoT)

## Summary
This project is a System Administration exercise designed to deepen your knowledge in using K3d, K3s, and Vagrant. You will learn to set up a personal virtual machine, use K3s for Kubernetes clusters, and streamline your workflow with K3d and Argo CD. The project is structured in a way to gradually introduce these tools, providing a minimal yet solid foundation in Kubernetes.

## Table of Contents
1. [Preamble](#preamble)
2. [Introduction](#introduction)
3. [General Guidelines](#general-guidelines)
4. [Mandatory Parts](#mandatory-parts)
    1. [Part 1: K3s and Vagrant](#part-1-k3s-and-vagrant)
    2. [Part 2: K3s and Three Simple Applications](#part-2-k3s-and-three-simple-applications)
    3. [Part 3: K3d and Argo CD](#part-3-k3d-and-argo-cd)
5. [Bonus Part](#bonus-part)
6. [Submission and Peer-Evaluation](#submission-and-peer-evaluation)

## Preamble
This project aims to deepen your knowledge by making you use K3d and K3s with Vagrant. These steps will get you started with Kubernetes, although mastering this complex tool requires further study.

## Introduction
You will set up a personal virtual machine with Vagrant and the distribution of your choice. Then, you will learn how to use K3s and its Ingress. Finally, you will discover K3d, which simplifies your Kubernetes setup and management. This project is a minimal introduction to Kubernetes.

## General Guidelines
- The entire project must be done in a virtual machine.
- All configuration files must be placed in folders at the root of your repository.
- Folders for the mandatory parts: `p1`, `p2`, and `p3`. Bonus part folder: `bonus`.
- You may need to read extensive documentation to learn how to use K8s with K3s and K3d.
- You can use any tools to set up your host virtual machine and Vagrant provider.

## Mandatory Parts

### Part 1: K3s and Vagrant
1. Set up two virtual machines using Vagrant.
2. Write a Vagrantfile with minimal resources: 1 CPU, 512 MB RAM (or 1024 MB).
3. Assign dedicated IPs: `192.168.56.110` (Server) and `192.168.56.111` (ServerWorker).
4. Enable SSH connection without a password.
5. Install K3s on both machines (controller mode on Server, agent mode on ServerWorker).
6. Install and use `kubectl`.

### Part 2: K3s and Three Simple Applications
1. Set up one virtual machine with the latest stable distribution and K3s in server mode.
2. Deploy three web applications accessible via different HOSTs (`app1.com`, `app2.com`, `app3.com`) on IP `192.168.56.110`.
3. Application 2 should have three replicas.

### Part 3: K3d and Argo CD
1. Install K3d on your virtual machine.
2. Set up Docker and any other necessary software via a script.
3. Create two namespaces: `argocd` for Argo CD and `dev` for an application.
4. Deploy an application in `dev` namespace using Argo CD and your GitHub repository.
5. Ensure the application can be updated via GitHub repository changes.

## Bonus Part
1. Set up a local Gitlab instance in your cluster.
2. Create a `gitlab` namespace.
3. Ensure all previous setups work with the local Gitlab.
