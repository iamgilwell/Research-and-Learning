# Kubernetes Terminology Cheat Sheet

## 🏗️ Infrastructure Components

| Term | Definition | Example |
|------|------------|---------|
| **Cluster** | Set of machines running Kubernetes | Production cluster with 5 nodes |
| **Node** | Physical/virtual machine in cluster | AWS EC2 instance, bare metal server |
| **Control Plane** | Kubernetes management components | API Server, etcd, Scheduler |
| **Worker Node** | Runs application workloads | Hosts pods and containers |

## 📦 Workload Resources

| Term | Definition | Example |
|------|------------|---------|
| **Pod** | Smallest deployable unit | nginx container + sidecar |
| **Container** | Packaged application | Docker container with app code |
| **Deployment** | Manages identical pods | Web app with 3 replicas |
| **Service** | Network endpoint for pods | Load balancer for web tier |

## 🔧 Configuration & Storage

| Term | Definition | Example |
|------|------------|---------|
| **ConfigMap** | Non-sensitive configuration | Database connection strings |
| **Secret** | Sensitive data | API keys, passwords |
| **Volume** | Storage for containers | Database data directory |
| **Namespace** | Virtual cluster isolation | dev, staging, production |

## 🌐 Networking

| Term | Definition | Example |
|------|------------|---------|
| **Service Discovery** | Finding services by name | api-service.default.svc.cluster.local |
| **Ingress** | HTTP/HTTPS load balancer | Routes traffic to web services |
| **Load Balancing** | Distribute traffic across pods | Round-robin to 3 web pods |

## 🔒 Security & Access

| Term | Definition | Example |
|------|------------|---------|
| **RBAC** | Role-based access control | Developers can read, not delete |
| **Service Account** | Identity for pods | Pod accessing Kubernetes API |
| **Security Context** | Container security settings | Run as non-root user |

## 📊 Monitoring & Health

| Term | Definition | Example |
|------|------------|---------|
| **Liveness Probe** | Restart unhealthy containers | HTTP check on /health |
| **Readiness Probe** | Remove from service if not ready | Database connection check |
| **Metrics** | System measurements | CPU usage, memory consumption |

## 🎛️ Resource Management

| Term | Definition | Example |
|------|------------|---------|
| **Resource Requests** | Minimum guaranteed resources | 100m CPU, 128Mi memory |
| **Resource Limits** | Maximum allowed resources | 500m CPU, 512Mi memory |
| **Scheduler** | Assigns pods to nodes | Places pod on node with resources |

## 📋 Common Abbreviations

| Short | Full Name | Usage |
|-------|-----------|-------|
| **k8s** | Kubernetes | "Deploy to k8s cluster" |
| **ns** | Namespace | `kubectl get pods -n kube-system` |
| **svc** | Service | `kubectl get svc` |
| **deploy** | Deployment | `kubectl get deploy` |
| **cm** | ConfigMap | `kubectl get cm` |
| **pv** | Persistent Volume | `kubectl get pv` |
| **pvc** | Persistent Volume Claim | `kubectl get pvc` |

## 🔄 Object Lifecycle States

| State | Meaning | Next Action |
|-------|---------|-------------|
| **Pending** | Being scheduled | Wait for node assignment |
| **Running** | Active and healthy | Monitor for issues |
| **Succeeded** | Completed successfully | Clean up if needed |
| **Failed** | Terminated with error | Check logs, debug |
| **Unknown** | Status unclear | Investigate node/network |

## 📝 YAML Structure

```yaml
apiVersion: v1           # API version
kind: Pod               # Resource type
metadata:               # Object information
  name: my-pod         # Object name
  labels:              # Key-value tags
    app: web
spec:                  # Desired state
  containers:          # Container specifications
  - name: nginx
    image: nginx:1.21
status:                # Current state (managed by k8s)
  phase: Running
```

## 🚀 Quick Commands Reference

| Command | Purpose | Example |
|---------|---------|---------|
| `kubectl get` | List resources | `kubectl get pods` |
| `kubectl describe` | Detailed info | `kubectl describe pod nginx` |
| `kubectl apply` | Create/update | `kubectl apply -f app.yaml` |
| `kubectl delete` | Remove | `kubectl delete pod nginx` |
| `kubectl logs` | View logs | `kubectl logs nginx` |
| `kubectl exec` | Run commands | `kubectl exec -it nginx -- bash` |

## 💡 Key Concepts to Remember

1. **Pods are ephemeral** - They come and go, don't rely on specific instances
2. **Services provide stability** - Consistent endpoint even as pods change
3. **Labels enable selection** - How services find pods, deployments manage replicas
4. **Namespaces provide isolation** - Separate environments within same cluster
5. **Controllers maintain state** - Automatically fix drift from desired state
6. **Everything is an API object** - Consistent interface for all resources

---

**💡 Pro Tip**: Keep this cheat sheet handy while learning. The terminology becomes natural with practice!

**📚 For complete definitions**: See [Full Glossary](../GLOSSARY.md)
