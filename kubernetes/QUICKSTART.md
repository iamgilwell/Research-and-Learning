# Kubernetes Tutorial - Quick Start Guide

## 🚀 Get Started in 5 Minutes

### 1. Setup Your Environment
```bash
# Navigate to tutorial directory
cd /mnt/RESEARCH/Projects/tutorials/os-learning/kubernetes

# Setup local Kubernetes cluster (automated)
make setup
```

### 2. Deploy Your First Pod
```bash
# Deploy simple nginx pod
make deploy-nginx

# Check if it's running
kubectl get pods

# Access the web server
kubectl port-forward hello-nginx 8080:80
# Open http://localhost:8080 in browser
```

### 3. Try Multi-Container Example
```bash
# Deploy multi-container pod
make deploy-multi

# Watch it start up
kubectl get pods -w

# Access the dynamic content
kubectl port-forward multi-container-demo 8080:80
# Open http://localhost:8080 in browser
```

### 4. Explore with k9s
```bash
# Launch terminal UI for Kubernetes
make k9s

# Navigate with arrow keys, press 'q' to quit
```

## 📚 Learning Path

### Week 1: Fundamentals
- [Module 0: Terminology](modules/00-terminology.md)
- [Module 1: Introduction](modules/01-introduction.md)
- [Module 2: Architecture](modules/02-architecture.md)  
- [Module 3: Setup](modules/03-setup.md)
- [Exercise 1: First Pod](exercises/exercise01.md)

### Week 2: Core Concepts
- [Module 4: Pods](modules/04-pods.md)
- [Exercise 2: Multi-Container](exercises/exercise02.md)

## 🛠️ Essential Commands

```bash
# Cluster management
kubectl get nodes                    # List cluster nodes
kubectl cluster-info                 # Show cluster information

# Pod operations
kubectl get pods                     # List pods
kubectl describe pod <name>          # Detailed pod info
kubectl logs <pod-name>             # View pod logs
kubectl exec -it <pod> -- /bin/bash # Execute into pod

# Apply configurations
kubectl apply -f <file.yaml>        # Deploy from file
kubectl delete -f <file.yaml>       # Remove from file

# Port forwarding
kubectl port-forward <pod> 8080:80  # Forward local port to pod
```

## 🧪 Test Everything Works

```bash
# Run automated tests
make test

# Check cluster status
make status

# Validate all YAML files
make validate
```

## 🔧 Troubleshooting

### Pod Won't Start
```bash
# Check pod events
kubectl describe pod <pod-name>

# Check node resources
kubectl top nodes

# View detailed events
kubectl get events --sort-by='.lastTimestamp'
```

### Can't Access Application
```bash
# Verify pod is running
kubectl get pods -o wide

# Check port forwarding
kubectl port-forward <pod> 8080:80

# Test from inside cluster
kubectl run test --image=busybox --rm -it -- wget -qO- http://<pod-ip>
```

### Cluster Issues
```bash
# Recreate cluster
make reset

# Check Docker is running
docker ps

# Verify kind installation
kind version
```

## 📖 Next Steps

1. **Complete Exercise 1**: [Your First Pod](exercises/exercise01.md)
2. **Try Exercise 2**: [Multi-Container Pod](exercises/exercise02.md)
3. **Explore Examples**: Check `examples/` directory
4. **Read Modules**: Start with [Introduction](modules/01-introduction.md)

## 🎯 Quick Reference

| Command | Description |
|---------|-------------|
| `make setup` | Create local cluster |
| `make examples` | Deploy all examples |
| `make test` | Run test suite |
| `make clean` | Remove all resources |
| `make k9s` | Launch terminal UI |
| `make help` | Show all commands |

## 🆘 Getting Help

- **Check logs**: `kubectl logs <pod-name>`
- **Describe resources**: `kubectl describe <resource> <name>`
- **View events**: `kubectl get events`
- **Use k9s**: Visual interface for debugging

---

**Ready to learn Kubernetes?** Start with [Module 0: Terminology](modules/00-terminology.md)
