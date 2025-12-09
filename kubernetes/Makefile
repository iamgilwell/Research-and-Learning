# Kubernetes Tutorial Makefile

# Variables
CLUSTER_NAME ?= k8s-learning
KUBECTL ?= kubectl
NAMESPACE ?= default

# Default target
.PHONY: all clean test help setup examples

# Setup cluster and environment
setup:
	@echo "Setting up Kubernetes learning environment..."
	./tools/setup-cluster.sh

# Deploy all examples
examples:
	@echo "Deploying example manifests..."
	@for file in examples/*.yaml; do \
		echo "Applying $$file..."; \
		$(KUBECTL) apply -f $$file; \
	done
	@echo "Examples deployed. Check with: kubectl get pods"

# Deploy solutions
solutions:
	@echo "Deploying solution manifests..."
	@for file in solutions/*.yaml; do \
		echo "Applying $$file..."; \
		$(KUBECTL) apply -f $$file; \
	done
	@echo "Solutions deployed. Check with: kubectl get pods"

# Run tests
test:
	@echo "Running test suite..."
	cd tests && ./run_tests.sh all

# Test specific module
test-setup:
	cd tests && ./run_tests.sh setup

test-examples:
	cd tests && ./run_tests.sh examples

test-solutions:
	cd tests && ./run_tests.sh solutions

# Clean up all resources
clean:
	@echo "Cleaning up Kubernetes resources..."
	-$(KUBECTL) delete -f examples/ --ignore-not-found=true
	-$(KUBECTL) delete -f solutions/ --ignore-not-found=true
	-$(KUBECTL) delete namespace development --ignore-not-found=true
	@echo "Cleanup completed"

# Clean up and delete cluster
clean-cluster:
	@echo "Deleting kind cluster..."
	kind delete cluster --name $(CLUSTER_NAME)

# Reset everything
reset: clean-cluster setup

# Check cluster status
status:
	@echo "Cluster Status:"
	@echo "==============="
	$(KUBECTL) cluster-info
	@echo ""
	@echo "Nodes:"
	$(KUBECTL) get nodes -o wide
	@echo ""
	@echo "Pods:"
	$(KUBECTL) get pods --all-namespaces
	@echo ""
	@echo "Services:"
	$(KUBECTL) get services --all-namespaces

# Create development namespace
namespace:
	$(KUBECTL) create namespace development --dry-run=client -o yaml | $(KUBECTL) apply -f -

# Port forward common services
port-forward-nginx:
	@echo "Port forwarding nginx pod to localhost:8080..."
	$(KUBECTL) port-forward pod/hello-nginx 8080:80

port-forward-multi:
	@echo "Port forwarding multi-container pod to localhost:8080..."
	$(KUBECTL) port-forward pod/multi-container-demo 8080:80

# View logs
logs-nginx:
	$(KUBECTL) logs hello-nginx

logs-multi:
	$(KUBECTL) logs multi-container-demo --all-containers=true

# Execute into pods
exec-nginx:
	$(KUBECTL) exec -it hello-nginx -- /bin/bash

exec-multi:
	$(KUBECTL) exec -it multi-container-demo -c web-app -- /bin/bash

# Describe resources
describe-nginx:
	$(KUBECTL) describe pod hello-nginx

describe-multi:
	$(KUBECTL) describe pod multi-container-demo

# Watch resources
watch-pods:
	watch $(KUBECTL) get pods -o wide

watch-all:
	watch $(KUBECTL) get all

# Validate YAML files
validate:
	@echo "Validating YAML files..."
	@for file in examples/*.yaml solutions/*.yaml; do \
		echo "Validating $$file..."; \
		$(KUBECTL) apply --dry-run=client -f $$file > /dev/null && echo "✓ $$file" || echo "✗ $$file"; \
	done

# Generate documentation
docs:
	@echo "Generating documentation..."
	@echo "# Kubernetes Tutorial Resources" > RESOURCES.md
	@echo "" >> RESOURCES.md
	@echo "## Examples" >> RESOURCES.md
	@for file in examples/*.yaml; do \
		echo "- [$$file]($$file)" >> RESOURCES.md; \
	done
	@echo "" >> RESOURCES.md
	@echo "## Solutions" >> RESOURCES.md
	@for file in solutions/*.yaml; do \
		echo "- [$$file]($$file)" >> RESOURCES.md; \
	done
	@echo "Documentation generated: RESOURCES.md"

# Install additional tools
tools:
	@echo "Installing additional Kubernetes tools..."
	# Install kubectx/kubens if not present
	@if ! command -v kubectx > /dev/null; then \
		echo "Installing kubectx/kubens..."; \
		sudo git clone https://github.com/ahmetb/kubectx /opt/kubectx; \
		sudo ln -sf /opt/kubectx/kubectx /usr/local/bin/kubectx; \
		sudo ln -sf /opt/kubectx/kubens /usr/local/bin/kubens; \
	fi
	# Install k9s if not present
	@if ! command -v k9s > /dev/null; then \
		echo "Installing k9s..."; \
		curl -sS https://webinstall.dev/k9s | bash; \
	fi
	@echo "Tools installation completed"

# Launch k9s
k9s:
	k9s

# Quick deployment shortcuts
deploy-nginx:
	$(KUBECTL) apply -f examples/01-hello-pod.yaml

deploy-multi:
	$(KUBECTL) apply -f examples/02-multi-container.yaml

deploy-health:
	$(KUBECTL) apply -f examples/03-health-checks.yaml

# Help target
help:
	@echo "Kubernetes Tutorial Makefile"
	@echo "============================"
	@echo ""
	@echo "Setup Commands:"
	@echo "  setup           - Set up local Kubernetes cluster"
	@echo "  tools           - Install additional tools (kubectx, k9s)"
	@echo "  namespace       - Create development namespace"
	@echo ""
	@echo "Deployment Commands:"
	@echo "  examples        - Deploy all example manifests"
	@echo "  solutions       - Deploy all solution manifests"
	@echo "  deploy-nginx    - Deploy simple nginx pod"
	@echo "  deploy-multi    - Deploy multi-container pod"
	@echo "  deploy-health   - Deploy health check example"
	@echo ""
	@echo "Testing Commands:"
	@echo "  test            - Run all tests"
	@echo "  test-setup      - Test cluster setup"
	@echo "  test-examples   - Test example deployments"
	@echo "  test-solutions  - Test solution deployments"
	@echo "  validate        - Validate YAML syntax"
	@echo ""
	@echo "Monitoring Commands:"
	@echo "  status          - Show cluster status"
	@echo "  watch-pods      - Watch pod status"
	@echo "  watch-all       - Watch all resources"
	@echo "  k9s             - Launch k9s terminal UI"
	@echo ""
	@echo "Access Commands:"
	@echo "  port-forward-nginx  - Port forward nginx pod"
	@echo "  port-forward-multi  - Port forward multi-container pod"
	@echo "  logs-nginx      - View nginx pod logs"
	@echo "  logs-multi      - View multi-container pod logs"
	@echo "  exec-nginx      - Execute into nginx pod"
	@echo "  exec-multi      - Execute into multi-container pod"
	@echo ""
	@echo "Cleanup Commands:"
	@echo "  clean           - Remove all deployed resources"
	@echo "  clean-cluster   - Delete the entire cluster"
	@echo "  reset           - Clean and recreate cluster"
	@echo ""
	@echo "Utility Commands:"
	@echo "  docs            - Generate documentation"
	@echo "  help            - Show this help message"
