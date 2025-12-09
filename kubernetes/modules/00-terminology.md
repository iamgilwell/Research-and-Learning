# Module 0: Kubernetes Terminology & Glossary

## Essential Kubernetes Terms

### Core Infrastructure

**Cluster**
- A set of machines (nodes) that run containerized applications managed by Kubernetes
- Consists of control plane + worker nodes
- Example: Production cluster with 3 master nodes + 10 worker nodes

**Node**
- A physical or virtual machine in the cluster
- **Control Plane Node**: Runs Kubernetes management components
- **Worker Node**: Runs application workloads (pods)

**Control Plane**
- The brain of Kubernetes cluster
- Makes decisions about scheduling, scaling, and cluster state
- Components: API Server, etcd, Scheduler, Controller Manager

**kubelet**
- Agent running on each node
- Communicates with control plane
- Manages pods and containers on its node

**Container Runtime**
- Software that runs containers (Docker, containerd, CRI-O)
- Pulls images, creates containers, manages container lifecycle

### Workload Resources

**Pod**
- Smallest deployable unit in Kubernetes
- Contains one or more containers that share network and storage
- Ephemeral - pods come and go

**Container**
- Packaged application with its dependencies
- Runs inside pods
- Based on container images (like Docker images)

**Image**
- Read-only template for creating containers
- Contains application code, runtime, libraries, and dependencies
- Stored in registries (Docker Hub, ECR, GCR)

**Deployment**
- Manages a set of identical pods
- Provides declarative updates and rollback capabilities
- Ensures desired number of replicas are running

**ReplicaSet**
- Ensures a specified number of pod replicas are running
- Usually managed by Deployments
- Replaces failed pods automatically

**Service**
- Stable network endpoint for accessing pods
- Provides load balancing across pod replicas
- Types: ClusterIP, NodePort, LoadBalancer, ExternalName

**Ingress**
- HTTP/HTTPS load balancer and reverse proxy
- Routes external traffic to services
- Provides SSL termination, path-based routing

### Configuration & Storage

**ConfigMap**
- Stores non-sensitive configuration data
- Can be mounted as files or environment variables
- Separates configuration from application code

**Secret**
- Stores sensitive data (passwords, tokens, keys)
- Base64 encoded (not encrypted by default)
- Can be mounted as files or environment variables

**Volume**
- Directory accessible to containers in a pod
- Persists data beyond container lifecycle
- Types: emptyDir, hostPath, persistentVolumeClaim

**Persistent Volume (PV)**
- Cluster-wide storage resource
- Independent of pod lifecycle
- Provisioned by administrator or dynamically

**Persistent Volume Claim (PVC)**
- Request for storage by a pod
- Binds to available Persistent Volumes
- Specifies size, access mode, storage class

**Storage Class**
- Defines types of storage available
- Enables dynamic provisioning of volumes
- Examples: fast-ssd, slow-hdd, replicated-storage

### Networking

**Service Discovery**
- Mechanism for finding and connecting to services
- Uses DNS names (service-name.namespace.svc.cluster.local)
- Automatic registration of services

**Load Balancing**
- Distributes traffic across multiple pod replicas
- Built into Services
- Algorithms: round-robin, session affinity

**Network Policy**
- Firewall rules for pod-to-pod communication
- Controls ingress and egress traffic
- Requires CNI plugin support

**CNI (Container Network Interface)**
- Standard for configuring network interfaces
- Plugins: Calico, Flannel, Weave, Cilium
- Provides pod-to-pod networking

### Security & Access Control

**RBAC (Role-Based Access Control)**
- Authorization mechanism
- Controls who can do what in the cluster
- Components: Roles, RoleBindings, ClusterRoles, ClusterRoleBindings

**Service Account**
- Identity for processes running in pods
- Used for pod-to-API server authentication
- Each namespace has a default service account

**Security Context**
- Security settings for pods and containers
- Controls user ID, group ID, capabilities, SELinux labels
- Implements principle of least privilege

**Namespace**
- Virtual cluster within a physical cluster
- Provides scope for names and resources
- Enables multi-tenancy and resource isolation

### Scheduling & Resource Management

**Scheduler**
- Component that assigns pods to nodes
- Considers resource requirements, constraints, and policies
- Pluggable and customizable

**Resource Requests**
- Minimum resources guaranteed to a container
- Used by scheduler for placement decisions
- CPU measured in millicores (m), memory in bytes

**Resource Limits**
- Maximum resources a container can use
- Prevents resource starvation
- Container killed if it exceeds memory limit

**Quality of Service (QoS)**
- Pod classification based on resource specifications
- Classes: Guaranteed, Burstable, BestEffort
- Affects eviction priority during resource pressure

**Node Affinity**
- Rules for pod placement on specific nodes
- Based on node labels and selectors
- Types: requiredDuringScheduling, preferredDuringScheduling

**Taints and Tolerations**
- Mechanism to repel pods from nodes
- Taint: Applied to nodes to mark them as unsuitable
- Toleration: Applied to pods to allow scheduling on tainted nodes

### Observability & Monitoring

**Health Checks (Probes)**
- Mechanisms to check container health
- **Liveness**: Restart container if unhealthy
- **Readiness**: Remove from service if not ready
- **Startup**: Handle slow-starting containers

**Metrics**
- Numerical measurements of system behavior
- CPU usage, memory consumption, request rates
- Collected by Prometheus, viewed in Grafana

**Logs**
- Text records of application and system events
- Aggregated by tools like Fluentd, Elasticsearch
- Essential for debugging and monitoring

**Events**
- Records of cluster activities and state changes
- Generated by Kubernetes components
- Useful for troubleshooting

### Advanced Concepts

**Operator**
- Custom controller that extends Kubernetes API
- Encodes operational knowledge for specific applications
- Examples: Prometheus Operator, MySQL Operator

**Custom Resource Definition (CRD)**
- Extends Kubernetes API with custom resources
- Allows defining application-specific objects
- Used by operators and advanced applications

**Helm**
- Package manager for Kubernetes
- **Chart**: Package of Kubernetes manifests
- **Release**: Deployed instance of a chart

**StatefulSet**
- Manages stateful applications
- Provides stable network identities and persistent storage
- Ordered deployment and scaling

**DaemonSet**
- Ensures a pod runs on every node
- Used for system services (logging, monitoring, networking)
- Automatically schedules on new nodes

**Job**
- Runs pods to completion
- Used for batch processing and one-time tasks
- Ensures specified number of successful completions

**CronJob**
- Runs jobs on a schedule
- Based on cron syntax
- Used for periodic tasks (backups, reports)

### Container & Image Concepts

**Registry**
- Storage and distribution system for container images
- Examples: Docker Hub, Amazon ECR, Google GCR
- Can be public or private

**Tag**
- Label for specific version of an image
- Examples: nginx:1.21, myapp:v2.0.1, latest
- Used to specify which image version to deploy

**Dockerfile**
- Text file with instructions to build container images
- Defines base image, dependencies, and configuration
- Used by docker build command

**Image Pull Policy**
- Controls when Kubernetes pulls container images
- **Always**: Pull on every pod creation
- **IfNotPresent**: Pull only if image not cached
- **Never**: Never pull, use cached image only

### Kubernetes API & Objects

**API Server**
- REST API for all Kubernetes operations
- Central component that validates and processes requests
- Stores state in etcd

**etcd**
- Distributed key-value store
- Stores all cluster state and configuration
- Provides consistency and high availability

**API Version**
- Version of Kubernetes API for resources
- Examples: v1, apps/v1, networking.k8s.io/v1
- Indicates stability and feature set

**Kind**
- Type of Kubernetes object
- Examples: Pod, Service, Deployment, ConfigMap
- Specified in YAML manifests

**Metadata**
- Information about Kubernetes objects
- Includes name, namespace, labels, annotations
- Used for identification and organization

**Spec**
- Desired state specification for objects
- Describes what you want the resource to look like
- Processed by controllers to achieve desired state

**Status**
- Current state of objects
- Maintained by Kubernetes controllers
- Shows actual vs desired state

### Labels & Selectors

**Labels**
- Key-value pairs attached to objects
- Used for organization and selection
- Examples: app=nginx, version=v1.2, environment=production

**Selectors**
- Queries that match objects based on labels
- Used by Services to find pods
- Types: equality-based, set-based

**Annotations**
- Key-value pairs for non-identifying metadata
- Used for tools, libraries, and external systems
- Not used for selection or grouping

## Quick Reference

### Resource Hierarchy
```
Cluster
├── Namespaces
│   ├── Pods
│   ├── Services
│   ├── Deployments
│   ├── ConfigMaps
│   └── Secrets
└── Nodes
    ├── kubelet
    ├── kube-proxy
    └── Container Runtime
```

### Common Abbreviations
- **k8s**: Kubernetes (8 letters between 'k' and 's')
- **ns**: Namespace
- **svc**: Service
- **deploy**: Deployment
- **cm**: ConfigMap
- **pv**: Persistent Volume
- **pvc**: Persistent Volume Claim
- **sa**: Service Account

### Resource Naming Convention
- **Lowercase**: All resource names must be lowercase
- **DNS-1123**: Must be valid DNS subdomain names
- **Hyphens**: Use hyphens, not underscores
- **Examples**: web-server, api-gateway, user-database

---

**Next Module**: [Introduction to Kubernetes](01-introduction.md)
**Complete Reference**: [Full Glossary](../GLOSSARY.md)
