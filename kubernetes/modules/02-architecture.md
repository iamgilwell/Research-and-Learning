# Module 2: Kubernetes Architecture

## Cluster Architecture Overview

A Kubernetes cluster consists of a control plane and worker nodes.

```
┌─────────────────────────────────────────────────────────┐
│                    Control Plane                        │
├─────────────┬─────────────┬─────────────┬─────────────┤
│ API Server  │   etcd      │ Scheduler   │ Controller  │
│             │             │             │ Manager     │
└─────────────┴─────────────┴─────────────┴─────────────┘
       │                │                │
       │                │                │
┌──────▼────────┐ ┌─────▼─────┐ ┌────────▼────────┐
│  Worker Node  │ │Worker Node│ │  Worker Node    │
│ ┌───────────┐ │ │┌─────────┐│ │ ┌─────────────┐ │
│ │  kubelet  │ │ ││ kubelet ││ │ │   kubelet   │ │
│ │ kube-proxy│ │ ││kube-proxy││ │ │ kube-proxy  │ │
│ │Container  │ │ ││Container││ │ │ Container   │ │
│ │Runtime    │ │ ││Runtime  ││ │ │ Runtime     │ │
│ └───────────┘ │ │└─────────┘│ │ └─────────────┘ │
└───────────────┘ └───────────┘ └─────────────────┘
```

## Control Plane Components

### API Server (kube-apiserver)
**The front door to Kubernetes**

```bash
# All interactions go through the API server
kubectl get pods  # → API Server → etcd
kubectl apply -f deployment.yaml  # → API Server → etcd
```

**Responsibilities:**
- Validates and processes API requests
- Authentication and authorization
- Admission control
- Stores data in etcd

**Example API Request:**
```bash
curl -X GET https://k8s-api:6443/api/v1/pods \
  -H "Authorization: Bearer $TOKEN"
```

### etcd
**The cluster's database**

```
┌─────────────────────────────────────┐
│              etcd                   │
├─────────────────────────────────────┤
│ /registry/pods/default/nginx-pod    │
│ /registry/services/default/nginx    │
│ /registry/deployments/default/app   │
│ /registry/configmaps/default/config │
└─────────────────────────────────────┘
```

**Characteristics:**
- Distributed key-value store
- Consistent and highly available
- Stores all cluster state
- Only API server communicates with etcd

### Scheduler (kube-scheduler)
**Decides where pods should run**

```yaml
# Pod without node assignment
apiVersion: v1
kind: Pod
metadata:
  name: nginx
spec:
  containers:
  - name: nginx
    image: nginx
  # nodeName: <-- Scheduler fills this
```

**Scheduling Process:**
1. **Filtering**: Find nodes that can run the pod
2. **Scoring**: Rank suitable nodes
3. **Binding**: Assign pod to best node

**Scheduling Factors:**
- Resource requirements (CPU, memory)
- Node affinity/anti-affinity
- Taints and tolerations
- Data locality

### Controller Manager (kube-controller-manager)
**Ensures desired state matches actual state**

```
┌─────────────────────────────────────┐
│        Controller Manager           │
├─────────────────────────────────────┤
│ • Deployment Controller             │
│ • ReplicaSet Controller             │
│ • Service Controller                │
│ • Node Controller                   │
│ • Endpoint Controller               │
│ • Namespace Controller              │
└─────────────────────────────────────┘
```

**Control Loop Example:**
```
1. Read desired state (3 replicas)
2. Read actual state (2 replicas)
3. Take action (create 1 more pod)
4. Repeat every few seconds
```

## Worker Node Components

### kubelet
**The node agent**

```bash
# kubelet responsibilities
systemctl status kubelet
journalctl -u kubelet -f
```

**Functions:**
- Communicates with API server
- Manages pod lifecycle
- Reports node and pod status
- Runs health checks

**Pod Lifecycle:**
```
Pending → Running → Succeeded/Failed
   ↑         ↑           ↑
kubelet  kubelet    kubelet
```

### kube-proxy
**Network proxy and load balancer**

```yaml
# Service definition
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  selector:
    app: nginx
  ports:
  - port: 80
    targetPort: 80
```

**kube-proxy creates:**
```bash
# iptables rules for load balancing
iptables -t nat -L | grep nginx-service
```

**Proxy Modes:**
- **iptables**: Default, uses netfilter rules
- **ipvs**: Higher performance for large clusters
- **userspace**: Legacy mode

### Container Runtime
**Runs the actual containers**

```
┌─────────────────────────────────────┐
│         Container Runtime           │
├─────────────────────────────────────┤
│ Docker, containerd, CRI-O           │
│                                     │
│ ┌─────────┐ ┌─────────┐ ┌─────────┐│
│ │Container│ │Container│ │Container││
│ │    A    │ │    B    │ │    C    ││
│ └─────────┘ └─────────┘ └─────────┘│
└─────────────────────────────────────┘
```

**Container Runtime Interface (CRI):**
- Standardized interface
- Pluggable runtimes
- OCI (Open Container Initiative) compliance

## Add-on Components

### DNS (CoreDNS)
**Service discovery within the cluster**

```yaml
# Automatic DNS records
nginx-service.default.svc.cluster.local → 10.96.0.1
```

### Dashboard
**Web-based UI for cluster management**

```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml
```

### Ingress Controller
**HTTP/HTTPS load balancing**

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: nginx-ingress
spec:
  rules:
  - host: example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: nginx-service
            port:
              number: 80
```

## Communication Flow

### Pod Creation Flow
```
1. kubectl apply → API Server
2. API Server → etcd (store pod spec)
3. Scheduler → API Server (watch for unscheduled pods)
4. Scheduler → API Server (bind pod to node)
5. kubelet → API Server (watch for pods on its node)
6. kubelet → Container Runtime (create container)
7. kubelet → API Server (report pod status)
```

### Service Request Flow
```
1. Client → kube-proxy (via Service IP)
2. kube-proxy → Pod IP (load balancing)
3. Pod → Response
4. Response → Client
```

## High Availability Architecture

### Multi-Master Setup
```
┌─────────────┐ ┌─────────────┐ ┌─────────────┐
│   Master 1  │ │   Master 2  │ │   Master 3  │
│ API Server  │ │ API Server  │ │ API Server  │
│ Scheduler   │ │ Scheduler   │ │ Scheduler   │
│ Controller  │ │ Controller  │ │ Controller  │
└─────────────┘ └─────────────┘ └─────────────┘
       │               │               │
       └───────────────┼───────────────┘
                       │
              ┌─────────────────┐
              │  Load Balancer  │
              └─────────────────┘
```

### etcd Clustering
```
┌─────────────┐ ┌─────────────┐ ┌─────────────┐
│   etcd-1    │ │   etcd-2    │ │   etcd-3    │
│   Leader    │ │  Follower   │ │  Follower   │
└─────────────┘ └─────────────┘ └─────────────┘
```

## Networking Architecture

### Cluster Networking Requirements
1. **Pod-to-Pod**: All pods can communicate without NAT
2. **Node-to-Pod**: Nodes can communicate with all pods
3. **Pod-to-Service**: Pods can reach services by name

### Network Model
```
┌─────────────────────────────────────┐
│              Node 1                 │
│ Pod A (10.244.1.2) ←→ Pod B (10.244.1.3) │
└─────────────────────────────────────┘
                    ↕
┌─────────────────────────────────────┐
│              Node 2                 │
│ Pod C (10.244.2.2) ←→ Pod D (10.244.2.3) │
└─────────────────────────────────────┘
```

### CNI (Container Network Interface)
Popular CNI plugins:
- **Calico**: L3 networking with BGP
- **Flannel**: Simple overlay network
- **Weave**: Mesh networking
- **Cilium**: eBPF-based networking

## Storage Architecture

### Volume Types
```yaml
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: app
    volumeMounts:
    - name: data
      mountPath: /data
  volumes:
  - name: data
    persistentVolumeClaim:
      claimName: data-pvc
```

### Storage Classes
```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: fast-ssd
provisioner: kubernetes.io/aws-ebs
parameters:
  type: gp3
  iops: "3000"
```

## Security Architecture

### Authentication Methods
- **X.509 Certificates**
- **Bearer Tokens**
- **OpenID Connect**
- **Service Account Tokens**

### Authorization (RBAC)
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: pod-reader
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get", "list"]
```

### Admission Controllers
```
API Request → Authentication → Authorization → Admission Controllers → etcd
```

## Observability Architecture

### Metrics Collection
```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│   kubelet   │───▶│ Prometheus  │───▶│   Grafana   │
│  (metrics)  │    │             │    │ (dashboard) │
└─────────────┘    └─────────────┘    └─────────────┘
```

### Log Aggregation
```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│ Application │───▶│ Fluentd/    │───▶│ Elasticsearch│
│    Logs     │    │ Fluent Bit  │    │ + Kibana    │
└─────────────┘    └─────────────┘    └─────────────┘
```

## Practice Exercise

### Explore Your Cluster
```bash
# Check cluster info
kubectl cluster-info
kubectl get nodes -o wide

# Examine control plane pods
kubectl get pods -n kube-system

# Check component status
kubectl get componentstatuses

# View cluster events
kubectl get events --all-namespaces

# Describe a node
kubectl describe node <node-name>
```

## Key Takeaways

- **Control Plane**: Manages cluster state and makes decisions
- **Worker Nodes**: Run application workloads
- **API Server**: Central communication hub
- **etcd**: Stores all cluster data
- **Controllers**: Maintain desired state
- **kubelet**: Node agent managing pods
- **Networking**: Flat network model with CNI plugins

---

**Next Module**: [Local Development Setup](03-setup.md)
