# Kubernetes Learning Tutorial

**Complete beginner-to-expert guide to Kubernetes container orchestration**

## 📚 Tutorial Structure

### Module 0: Foundation
- [00-terminology.md](modules/00-terminology.md) - Essential Terms & Glossary

### Module 1: Fundamentals
- [01-introduction.md](modules/01-introduction.md) - What is Kubernetes?
- [02-architecture.md](modules/02-architecture.md) - Cluster Architecture & Components
- [03-setup.md](modules/03-setup.md) - Local Development Setup

### Module 2: Core Concepts
- [04-pods.md](modules/04-pods.md) - Pods and Containers
- [05-services.md](modules/05-services.md) - Services and Networking
- [06-deployments.md](modules/06-deployments.md) - Deployments and ReplicaSets

### Module 3: Configuration & Storage
- [07-configmaps-secrets.md](modules/07-configmaps-secrets.md) - ConfigMaps and Secrets
- [08-volumes.md](modules/08-volumes.md) - Persistent Volumes and Storage
- [09-namespaces.md](modules/09-namespaces.md) - Namespaces and Resource Management

### Module 4: Advanced Workloads
- [10-daemonsets.md](modules/10-daemonsets.md) - DaemonSets and StatefulSets
- [11-jobs-cronjobs.md](modules/11-jobs-cronjobs.md) - Jobs and CronJobs
- [12-ingress.md](modules/12-ingress.md) - Ingress Controllers and Load Balancing

### Module 5: Security & Monitoring
- [13-rbac.md](modules/13-rbac.md) - RBAC and Security
- [14-monitoring.md](modules/14-monitoring.md) - Monitoring and Logging
- [15-troubleshooting.md](modules/15-troubleshooting.md) - Debugging and Troubleshooting

## 🛠️ Setup

### Prerequisites
```bash
# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Install kind (Kubernetes in Docker)
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind
```

### Quick Start
```bash
# Navigate to tutorial
cd /mnt/RESEARCH/Projects/tutorials/os-learning/kubernetes

# Create local cluster
./tools/setup-cluster.sh

# Deploy first application
kubectl apply -f examples/01-hello-pod.yaml

# Verify deployment
kubectl get pods
```

## 📖 Learning Path

**Beginner (Modules 1-3)**: 2-3 weeks
- Understand Kubernetes architecture
- Master basic workloads (Pods, Services, Deployments)
- Complete exercises 1-6

**Intermediate (Modules 4-5)**: 3-4 weeks  
- Advanced workload types and storage
- Security and monitoring concepts
- Complete exercises 7-12

**Advanced (Projects)**: 2-3 weeks
- Multi-tier applications
- Production deployment patterns
- Complete capstone projects

## 🧪 Testing Your Knowledge

Each module includes:
- **Examples**: Working YAML manifests with explanations
- **Exercises**: Hands-on practice problems
- **Tests**: Automated verification scripts

Run tests:
```bash
cd tests/
./run_tests.sh module01  # Test specific module
./run_tests.sh all       # Test everything
```

## 📁 Directory Structure

```
kubernetes/
├── README.md
├── modules/           # Tutorial modules
├── examples/          # YAML manifests and demos
├── exercises/         # Practice problems
├── tests/            # Automated tests
├── solutions/        # Exercise solutions
└── tools/            # Helper scripts
```

## 🎯 Learning Objectives

By completing this tutorial, you will:
- Understand Kubernetes architecture and components
- Deploy and manage containerized applications
- Configure networking, storage, and security
- Monitor and troubleshoot Kubernetes clusters
- Apply production-ready deployment patterns

## 🔗 Resources

- [Official Kubernetes Documentation](https://kubernetes.io/docs/)
- [Kubernetes API Reference](https://kubernetes.io/docs/reference/kubernetes-api/)
- [CNCF Landscape](https://landscape.cncf.io/)

---

**Start with Module 0**: [Kubernetes Terminology](modules/00-terminology.md)
