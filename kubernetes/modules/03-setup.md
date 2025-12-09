# Module 3: Local Development Setup

## Local Kubernetes Options

### Comparison of Local Solutions

| Tool | Pros | Cons | Best For |
|------|------|------|----------|
| **kind** | Fast, lightweight, CI/CD friendly | Docker required | Development, testing |
| **minikube** | Feature-rich, multiple drivers | Resource heavy | Learning, experimentation |
| **k3s** | Production-grade, minimal | Limited ecosystem | Edge, IoT, lightweight |
| **Docker Desktop** | Easy setup, integrated | macOS/Windows only | Beginners |

## Setup with kind (Kubernetes in Docker)

### Installation

```bash
# Install Docker (if not already installed)
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER
newgrp docker

# Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/

# Install kind
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-amd64
chmod +x kind
sudo mv kind /usr/local/bin/

# Verify installations
docker --version
kubectl version --client
kind --version
```

### Create Your First Cluster

```bash
# Create a simple cluster
kind create cluster --name learning-cluster

# Verify cluster is running
kubectl cluster-info --context kind-learning-cluster
kubectl get nodes
```

### Multi-Node Cluster Configuration

**File: cluster-config.yaml**
```yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
name: multi-node-cluster
nodes:
- role: control-plane
  kubeadmConfigPatches:
  - |
    kind: InitConfiguration
    nodeRegistration:
      kubeletExtraArgs:
        node-labels: "ingress-ready=true"
  extraPortMappings:
  - containerPort: 80
    hostPort: 80
    protocol: TCP
  - containerPort: 443
    hostPort: 443
    protocol: TCP
- role: worker
- role: worker
- role: worker
```

```bash
# Create multi-node cluster
kind create cluster --config cluster-config.yaml

# Verify nodes
kubectl get nodes
```

## Essential Tools Installation

### Helm (Package Manager)
```bash
# Install Helm
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Verify installation
helm version

# Add popular repositories
helm repo add stable https://charts.helm.sh/stable
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
```

### k9s (Terminal UI)
```bash
# Install k9s
curl -sS https://webinstall.dev/k9s | bash
source ~/.bashrc

# Launch k9s
k9s
```

### kubectx and kubens (Context Switching)
```bash
# Install kubectx and kubens
sudo git clone https://github.com/ahmetb/kubectx /opt/kubectx
sudo ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx
sudo ln -s /opt/kubectx/kubens /usr/local/bin/kubens

# Usage
kubectx                    # List contexts
kubectx kind-learning-cluster  # Switch context
kubens kube-system        # Switch namespace
```

## Development Environment Setup

### VS Code Extensions
```bash
# Install VS Code (if not installed)
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt update
sudo apt install code

# Essential extensions (install via VS Code)
# - Kubernetes
# - YAML
# - Docker
# - GitLens
```

### kubectl Configuration

**File: ~/.bashrc**
```bash
# kubectl autocompletion
source <(kubectl completion bash)
alias k=kubectl
complete -F __start_kubectl k

# Useful aliases
alias kgp='kubectl get pods'
alias kgs='kubectl get services'
alias kgd='kubectl get deployments'
alias kdp='kubectl describe pod'
alias kds='kubectl describe service'
alias kdd='kubectl describe deployment'
```

### Shell Prompt Enhancement
```bash
# Install kube-ps1 for context in prompt
git clone https://github.com/jonmosco/kube-ps1.git ~/.kube-ps1
echo 'source ~/.kube-ps1/kube-ps1.sh' >> ~/.bashrc
echo 'PS1="[\u@\h \W \$(kube_ps1)]\$ "' >> ~/.bashrc
source ~/.bashrc
```

## Your First Application Deployment

### 1. Create a Simple Pod

**File: hello-pod.yaml**
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: hello-nginx
  labels:
    app: hello
spec:
  containers:
  - name: nginx
    image: nginx:1.21
    ports:
    - containerPort: 80
```

```bash
# Deploy the pod
kubectl apply -f hello-pod.yaml

# Check pod status
kubectl get pods
kubectl describe pod hello-nginx

# View pod logs
kubectl logs hello-nginx

# Execute commands in pod
kubectl exec -it hello-nginx -- /bin/bash
```

### 2. Create a Service

**File: hello-service.yaml**
```yaml
apiVersion: v1
kind: Service
metadata:
  name: hello-service
spec:
  selector:
    app: hello
  ports:
  - protocol: TCP
    port: 80
    targetPort: 80
  type: NodePort
```

```bash
# Deploy the service
kubectl apply -f hello-service.yaml

# Check service
kubectl get services
kubectl describe service hello-service

# Get service URL
kubectl get service hello-service -o wide
```

### 3. Access Your Application

```bash
# Port forward to access locally
kubectl port-forward pod/hello-nginx 8080:80

# In another terminal, test the connection
curl http://localhost:8080

# Or access via NodePort
docker ps  # Find kind container
docker exec -it <kind-container> curl localhost:<nodeport>
```

### 4. Create a Deployment

**File: hello-deployment.yaml**
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: hello-deployment
spec:
  replicas: 3
  selector:
    matchLabels:
      app: hello
  template:
    metadata:
      labels:
        app: hello
    spec:
      containers:
      - name: nginx
        image: nginx:1.21
        ports:
        - containerPort: 80
```

```bash
# Deploy the deployment
kubectl apply -f hello-deployment.yaml

# Watch pods being created
kubectl get pods -w

# Scale the deployment
kubectl scale deployment hello-deployment --replicas=5
kubectl get pods

# Update the deployment
kubectl set image deployment/hello-deployment nginx=nginx:1.22
kubectl rollout status deployment/hello-deployment

# View rollout history
kubectl rollout history deployment/hello-deployment
```

## Cluster Management

### Cluster Information
```bash
# Cluster info
kubectl cluster-info
kubectl cluster-info dump

# Node information
kubectl get nodes -o wide
kubectl describe node <node-name>

# Resource usage
kubectl top nodes  # Requires metrics-server
kubectl top pods
```

### Namespace Management
```bash
# List namespaces
kubectl get namespaces

# Create namespace
kubectl create namespace development
kubectl create namespace production

# Set default namespace
kubectl config set-context --current --namespace=development

# Deploy to specific namespace
kubectl apply -f hello-pod.yaml -n production
```

### Resource Management
```bash
# View all resources
kubectl get all
kubectl get all --all-namespaces

# Resource quotas
kubectl describe quota -n development

# Limit ranges
kubectl describe limitrange -n development
```

## Troubleshooting Setup Issues

### Common Problems and Solutions

**1. Docker Permission Issues**
```bash
# Add user to docker group
sudo usermod -aG docker $USER
newgrp docker

# Test docker access
docker run hello-world
```

**2. kubectl Context Issues**
```bash
# List contexts
kubectl config get-contexts

# Switch context
kubectl config use-context kind-learning-cluster

# View current context
kubectl config current-context
```

**3. kind Cluster Issues**
```bash
# List kind clusters
kind get clusters

# Delete and recreate cluster
kind delete cluster --name learning-cluster
kind create cluster --name learning-cluster

# Check cluster logs
docker logs <kind-container-name>
```

**4. Port Conflicts**
```bash
# Check what's using port 80
sudo netstat -tulpn | grep :80

# Use different ports in kind config
# extraPortMappings:
# - containerPort: 80
#   hostPort: 8080
```

## Development Workflow

### 1. Code → Build → Deploy Cycle
```bash
# Build application
docker build -t myapp:v1 .

# Load image into kind cluster
kind load docker-image myapp:v1 --name learning-cluster

# Deploy to Kubernetes
kubectl apply -f deployment.yaml

# Update and redeploy
docker build -t myapp:v2 .
kind load docker-image myapp:v2 --name learning-cluster
kubectl set image deployment/myapp app=myapp:v2
```

### 2. Local Development with Skaffold
```bash
# Install Skaffold
curl -Lo skaffold https://storage.googleapis.com/skaffold/releases/latest/skaffold-linux-amd64
chmod +x skaffold
sudo mv skaffold /usr/local/bin

# Initialize Skaffold project
skaffold init

# Continuous development
skaffold dev
```

### 3. Configuration Management
```bash
# Use ConfigMaps for configuration
kubectl create configmap app-config --from-file=config.properties

# Use Secrets for sensitive data
kubectl create secret generic app-secrets --from-literal=password=secret123

# Apply configurations
kubectl apply -f configmap.yaml
kubectl apply -f secret.yaml
```

## Monitoring and Observability Setup

### Install Metrics Server
```bash
# Install metrics-server
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

# For kind, patch metrics-server to work with self-signed certs
kubectl patch deployment metrics-server -n kube-system --type='json' -p='[{"op": "add", "path": "/spec/template/spec/containers/0/args/-", "value": "--kubelet-insecure-tls"}]'

# Verify metrics
kubectl top nodes
kubectl top pods
```

### Install Dashboard (Optional)
```bash
# Install Kubernetes Dashboard
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml

# Create admin user
kubectl create serviceaccount admin-user -n kubernetes-dashboard
kubectl create clusterrolebinding admin-user --clusterrole=cluster-admin --serviceaccount=kubernetes-dashboard:admin-user

# Get access token
kubectl -n kubernetes-dashboard create token admin-user

# Access dashboard
kubectl proxy
# Open: http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/
```

## Cleanup and Reset

### Clean Up Resources
```bash
# Delete specific resources
kubectl delete -f hello-pod.yaml
kubectl delete -f hello-service.yaml
kubectl delete -f hello-deployment.yaml

# Delete by label
kubectl delete pods -l app=hello

# Delete namespace (and all resources in it)
kubectl delete namespace development
```

### Reset Cluster
```bash
# Delete kind cluster
kind delete cluster --name learning-cluster

# Recreate clean cluster
kind create cluster --name learning-cluster
```

## Next Steps Checklist

- [ ] kind cluster running successfully
- [ ] kubectl configured and working
- [ ] Essential tools installed (helm, k9s, etc.)
- [ ] First pod deployed and accessible
- [ ] Development workflow established
- [ ] Monitoring tools installed

## Key Takeaways

- **kind** provides fast, lightweight Kubernetes clusters
- **kubectl** is your primary interface to Kubernetes
- **Local development** mirrors production workflows
- **Proper tooling** significantly improves productivity
- **Iterative deployment** enables rapid development cycles

---

**Next Module**: [Pods and Containers](04-pods.md)
