#!/bin/bash

# Kubernetes Tutorial Test Runner
# Usage: ./run_tests.sh [module_name|all]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Test counters
TESTS_PASSED=0
TESTS_FAILED=0

# Function to print colored output
print_status() {
    local status=$1
    local message=$2
    
    case $status in
        "PASS")
            echo -e "${GREEN}[PASS]${NC} $message"
            ((TESTS_PASSED++))
            ;;
        "FAIL")
            echo -e "${RED}[FAIL]${NC} $message"
            ((TESTS_FAILED++))
            ;;
        "INFO")
            echo -e "${BLUE}[INFO]${NC} $message"
            ;;
        "WARN")
            echo -e "${YELLOW}[WARN]${NC} $message"
            ;;
    esac
}

# Function to check if kubectl is available and cluster is accessible
check_prerequisites() {
    print_status "INFO" "Checking prerequisites..."
    
    # Check kubectl
    if ! command -v kubectl &> /dev/null; then
        print_status "FAIL" "kubectl not found. Please install kubectl."
        return 1
    fi
    
    # Check cluster connectivity
    if ! kubectl cluster-info &> /dev/null; then
        print_status "FAIL" "Cannot connect to Kubernetes cluster. Please check your cluster setup."
        return 1
    fi
    
    # Check if we can create resources
    if ! kubectl auth can-i create pods &> /dev/null; then
        print_status "FAIL" "Insufficient permissions to create pods."
        return 1
    fi
    
    print_status "PASS" "Prerequisites check completed"
    return 0
}

# Function to test YAML file validity
test_yaml_validity() {
    local file=$1
    local name=$(basename "$file" .yaml)
    
    print_status "INFO" "Testing YAML validity: $file"
    
    # Check if file exists
    if [ ! -f "$file" ]; then
        print_status "FAIL" "$name - File not found"
        return 1
    fi
    
    # Validate YAML syntax
    if ! kubectl apply --dry-run=client -f "$file" &> /dev/null; then
        print_status "FAIL" "$name - Invalid YAML syntax"
        return 1
    fi
    
    print_status "PASS" "$name - YAML syntax valid"
    return 0
}

# Function to test pod deployment and functionality
test_pod_deployment() {
    local file=$1
    local name=$(basename "$file" .yaml)
    local timeout=${2:-60}
    
    print_status "INFO" "Testing pod deployment: $name"
    
    # Apply the manifest
    if ! kubectl apply -f "$file" &> /dev/null; then
        print_status "FAIL" "$name - Failed to apply manifest"
        return 1
    fi
    
    # Wait for pod to be ready
    local pod_name=$(kubectl get pods -l app=$(kubectl get -f "$file" -o jsonpath='{.metadata.labels.app}' 2>/dev/null || echo "test") -o jsonpath='{.items[0].metadata.name}' 2>/dev/null)
    
    if [ -z "$pod_name" ]; then
        # Try to get pod name from the manifest
        pod_name=$(kubectl get -f "$file" -o jsonpath='{.metadata.name}' 2>/dev/null)
    fi
    
    if [ -z "$pod_name" ]; then
        print_status "FAIL" "$name - Could not determine pod name"
        kubectl delete -f "$file" --ignore-not-found=true &> /dev/null
        return 1
    fi
    
    # Wait for pod to be running
    if ! kubectl wait --for=condition=Ready pod/$pod_name --timeout=${timeout}s &> /dev/null; then
        print_status "FAIL" "$name - Pod did not become ready within ${timeout}s"
        kubectl describe pod $pod_name
        kubectl delete -f "$file" --ignore-not-found=true &> /dev/null
        return 1
    fi
    
    print_status "PASS" "$name - Pod deployed and ready"
    
    # Clean up
    kubectl delete -f "$file" --ignore-not-found=true &> /dev/null
    return 0
}

# Function to test example files
test_examples() {
    print_status "INFO" "Testing example files..."
    
    local examples_dir="examples"
    if [ ! -d "$examples_dir" ]; then
        print_status "WARN" "Examples directory not found"
        return 0
    fi
    
    for file in "$examples_dir"/*.yaml; do
        if [ -f "$file" ]; then
            test_yaml_validity "$file"
            test_pod_deployment "$file" 90
        fi
    done
}

# Function to test solution files
test_solutions() {
    print_status "INFO" "Testing solution files..."
    
    local solutions_dir="solutions"
    if [ ! -d "$solutions_dir" ]; then
        print_status "WARN" "Solutions directory not found"
        return 0
    fi
    
    for file in "$solutions_dir"/*.yaml; do
        if [ -f "$file" ]; then
            test_yaml_validity "$file"
            test_pod_deployment "$file" 120
        fi
    done
}

# Function to test cluster setup
test_cluster_setup() {
    print_status "INFO" "Testing cluster setup..."
    
    # Check nodes
    local node_count=$(kubectl get nodes --no-headers | wc -l)
    if [ "$node_count" -gt 0 ]; then
        print_status "PASS" "Cluster has $node_count node(s)"
    else
        print_status "FAIL" "No nodes found in cluster"
        return 1
    fi
    
    # Check system pods
    local system_pods=$(kubectl get pods -n kube-system --no-headers | grep -c "Running" || echo "0")
    if [ "$system_pods" -gt 0 ]; then
        print_status "PASS" "$system_pods system pods running"
    else
        print_status "FAIL" "No system pods running"
        return 1
    fi
    
    # Test basic pod creation
    print_status "INFO" "Testing basic pod creation..."
    kubectl run test-pod --image=nginx:1.21 --restart=Never --rm --timeout=60s -- sleep 10 &> /dev/null
    if [ $? -eq 0 ]; then
        print_status "PASS" "Basic pod creation works"
    else
        print_status "FAIL" "Basic pod creation failed"
        return 1
    fi
    
    return 0
}

# Function to test specific module
test_module() {
    local module=$1
    
    echo "=========================================="
    echo "Testing Module: $module"
    echo "=========================================="
    
    case $module in
        "module01"|"01"|"setup")
            test_cluster_setup
            ;;
        "module02"|"02"|"pods")
            test_examples
            ;;
        "examples")
            test_examples
            ;;
        "solutions")
            test_solutions
            ;;
        *)
            print_status "FAIL" "Unknown module: $module"
            ;;
    esac
}

# Function to run comprehensive tests
test_comprehensive() {
    print_status "INFO" "Running comprehensive test suite..."
    
    # Test cluster setup
    test_cluster_setup
    
    # Test examples
    test_examples
    
    # Test solutions
    test_solutions
    
    # Test kubectl functionality
    print_status "INFO" "Testing kubectl functionality..."
    
    # Test namespace creation
    if kubectl create namespace test-namespace --dry-run=client -o yaml | kubectl apply -f - &> /dev/null; then
        print_status "PASS" "Namespace creation works"
        kubectl delete namespace test-namespace &> /dev/null
    else
        print_status "FAIL" "Namespace creation failed"
    fi
    
    # Test service creation
    if kubectl create service clusterip test-service --tcp=80:80 --dry-run=client -o yaml &> /dev/null; then
        print_status "PASS" "Service manifest generation works"
    else
        print_status "FAIL" "Service manifest generation failed"
    fi
}

# Main execution
main() {
    local target=${1:-"all"}
    
    echo "Kubernetes Tutorial Test Suite"
    echo "=============================="
    
    # Change to parent directory if we're in tests/
    if [[ $(basename "$PWD") == "tests" ]]; then
        cd ..
    fi
    
    # Check prerequisites
    if ! check_prerequisites; then
        exit 1
    fi
    
    echo
    
    if [ "$target" = "all" ]; then
        test_comprehensive
    else
        test_module "$target"
    fi
    
    echo
    echo "=========================================="
    echo "Test Summary"
    echo "=========================================="
    echo "Tests Passed: $TESTS_PASSED"
    echo "Tests Failed: $TESTS_FAILED"
    echo "Total Tests:  $((TESTS_PASSED + TESTS_FAILED))"
    
    if [ $TESTS_FAILED -eq 0 ]; then
        print_status "PASS" "All tests passed!"
        exit 0
    else
        print_status "FAIL" "Some tests failed!"
        exit 1
    fi
}

# Run main function with all arguments
main "$@"
