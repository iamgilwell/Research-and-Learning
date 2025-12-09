#!/bin/bash

# Kubernetes Cluster Setup Script
# Creates a local kind cluster with essential components

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
CLUSTER_NAME="k8s-learning"
KUBECTL_VERSION="v1.28.0"
KIND_VERSION="v0.20.0"

# Function to print colored output
print_status() {
    local status=$1
    local message=$2
    
    case $status in
        "INFO")
            echo -e "${BLUE}[INFO]${NC} $message"
            ;;
        "SUCCESS")
            echo -e "${GREEN}[SUCCESS]${NC} $message"
            ;;
        "WARNING")
            echo -e "${YELLOW}[WARNING]${NC} $message"
            ;;
        "ERROR")
            echo -e "${RED}[ERROR]${NC} $message"
            ;;
    esac
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Install Docker if not present
install_docker() {
    if ! command_exists docker; then
        print_status "INFO" "Installing Docker..."
        curl -fsSL https://get.docker.com -o get-docker.sh
        sudo sh get-docker.sh
        sudo usermod -aG docker $USER
        rm get-docker.sh
        print_status "SUCCESS" "Docker installed. Please log out and back in for group changes to take effect."
    else
        print_status "SUCCESS" "Docker is already installed"
    fi
}

# Install kubectl if not present
install_kubectl() {
    if ! command_exists kubectl; then
        print_status "INFO" "Installing kubectl..."
        curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"
        chmod +x kubectl
        sudo mv kubectl /usr/local/bin/
        print_status "SUCCESS" "kubectl installed"
    else
        print_status "SUCCESS" "kubectl is already installed"
    fi
}

# Install kind if not present
install_kind() {
    if ! command_exists kind; then
        print_status "INFO" "Installing kind..."
        curl -Lo ./kind "https://kind.sigs.k8s.io/dl/${KIND_VERSION}/kind-linux-amd64"
        chmod +x kind
        sudo mv kind /usr/local/bin/
        print_status "SUCCESS" "kind installed"
    else
        print_status "SUCCESS" "kind is already installed"
    fi
}

# Create kind cluster configuration
create_cluster_config() {
    print_status "INFO" "Creating cluster configuration..."
    
    cat > kind-config.yaml << EOF
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
name: ${CLUSTER_NAME}
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
networking:
  # WARNING: It is _strongly_ recommended that you keep this the default
  # (127.0.0.1) for security reasons. However it is possible to change this.
  apiServerAddress: "127.0.0.1"
  # By default the API server listens on a random open port.
  # You may choose a specific port but probably don't need to in most cases.
  # Using a random port makes it easier to spin up multiple clusters.
  apiServerPort: 6443
EOF
    
    print_status "SUCCESS" "Cluster configuration created"
}

# Create the kind cluster
create_cluster() {
    print_status "INFO" "Creating kind cluster: ${CLUSTER_NAME}..."
    
    # Check if cluster already exists
    if kind get clusters | grep -q "^${CLUSTER_NAME}$"; then
        print_status "WARNING" "Cluster ${CLUSTER_NAME} already exists"
        read -p "Do you want to delete and recreate it? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            kind delete cluster --name ${CLUSTER_NAME}
        else
            print_status "INFO" "Using existing cluster"
            return 0
        fi
    fi
    
    kind create cluster --config kind-config.yaml --wait 300s
    print_status "SUCCESS" "Cluster created successfully"
}

# Install essential cluster components
install_cluster_components() {
    print_status "INFO" "Installing essential cluster components..."
    
    # Install metrics-server
    print_status "INFO" "Installing metrics-server..."
    kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
    
    # Patch metrics-server for kind
    kubectl patch deployment metrics-server -n kube-system --type='json' \
        -p='[{"op": "add", "path": "/spec/template/spec/containers/0/args/-", "value": "--kubelet-insecure-tls"}]'
    
    # Install ingress-nginx
    print_status "INFO" "Installing ingress-nginx..."
    kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
    
    # Wait for ingress controller to be ready
    kubectl wait --namespace ingress-nginx \
        --for=condition=ready pod \
        --selector=app.kubernetes.io/component=controller \
        --timeout=300s
    
    print_status "SUCCESS" "Essential components installed"
}

# Setup kubectl context
setup_kubectl() {
    print_status "INFO" "Setting up kubectl context..."
    
    # Set context
    kubectl config use-context kind-${CLUSTER_NAME}
    
    # Verify cluster is working
    kubectl cluster-info
    kubectl get nodes
    
    print_status "SUCCESS" "kubectl configured successfully"
}

# Install helpful tools
install_tools() {
    print_status "INFO" "Installing helpful tools..."
    
    # Install helm
    if ! command_exists helm; then
        curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
        print_status "SUCCESS" "Helm installed"
    else
        print_status "SUCCESS" "Helm is already installed"
    fi
    
    # Install k9s (optional)
    if ! command_exists k9s; then
        print_status "INFO" "Installing k9s..."
        curl -sS https://webinstall.dev/k9s | bash
        print_status "SUCCESS" "k9s installed"
    else
        print_status "SUCCESS" "k9s is already installed"
    fi
}

# Setup bash completion and aliases
setup_shell() {
    print_status "INFO" "Setting up shell enhancements..."
    
    # Add to bashrc if not already present
    if ! grep -q "kubectl completion bash" ~/.bashrc; then
        cat >> ~/.bashrc << 'EOF'

# Kubernetes aliases and completion
source <(kubectl completion bash)
alias k=kubectl
complete -F __start_kubectl k

# Useful kubectl aliases
alias kgp='kubectl get pods'
alias kgs='kubectl get services'
alias kgd='kubectl get deployments'
alias kgn='kubectl get nodes'
alias kdp='kubectl describe pod'
alias kds='kubectl describe service'
alias kdd='kubectl describe deployment'
alias kaf='kubectl apply -f'
alias kdf='kubectl delete -f'
EOF
        print_status "SUCCESS" "Shell enhancements added to ~/.bashrc"
        print_status "INFO" "Run 'source ~/.bashrc' or restart your shell to activate"
    else
        print_status "SUCCESS" "Shell enhancements already configured"
    fi
}

# Create sample namespace and resources
create_samples() {
    print_status "INFO" "Creating sample resources..."
    
    # Create development namespace
    kubectl create namespace development --dry-run=client -o yaml | kubectl apply -f -
    
    # Create a sample deployment
    kubectl create deployment nginx-sample --image=nginx:1.21 -n development --dry-run=client -o yaml | kubectl apply -f -
    
    # Create a sample service
    kubectl expose deployment nginx-sample --port=80 --target-port=80 -n development --dry-run=client -o yaml | kubectl apply -f -
    
    print_status "SUCCESS" "Sample resources created in 'development' namespace"
}

# Cleanup function
cleanup() {
    rm -f kind-config.yaml get-docker.sh
}

# Main execution
main() {
    print_status "INFO" "Starting Kubernetes cluster setup..."
    
    # Check if running as root
    if [[ $EUID -eq 0 ]]; then
        print_status "ERROR" "This script should not be run as root"
        exit 1
    fi
    
    # Install prerequisites
    install_docker
    install_kubectl
    install_kind
    
    # Create and configure cluster
    create_cluster_config
    create_cluster
    setup_kubectl
    
    # Install components and tools
    install_cluster_components
    install_tools
    setup_shell
    create_samples
    
    # Cleanup
    cleanup
    
    print_status "SUCCESS" "Kubernetes cluster setup complete!"
    echo
    print_status "INFO" "Cluster Information:"
    echo "  Cluster Name: ${CLUSTER_NAME}"
    echo "  Context: kind-${CLUSTER_NAME}"
    echo "  Nodes: $(kubectl get nodes --no-headers | wc -l)"
    echo
    print_status "INFO" "Quick Start Commands:"
    echo "  kubectl get nodes"
    echo "  kubectl get pods -A"
    echo "  kubectl get services -n development"
    echo "  k9s  # Terminal UI for Kubernetes"
    echo
    print_status "INFO" "To delete the cluster later:"
    echo "  kind delete cluster --name ${CLUSTER_NAME}"
}

# Run main function
main "$@"
