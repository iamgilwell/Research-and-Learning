# Module 4: Pods and Containers

## What is a Pod?

A Pod is the smallest deployable unit in Kubernetes. It represents a group of one or more containers that:
- Share the same network (IP address and port space)
- Share storage volumes
- Are scheduled together on the same node
- Live and die together

### Pod vs Container

```
┌─────────────────────────────────────┐
│                Pod                  │
│ ┌─────────────┐ ┌─────────────────┐ │
│ │ Container A │ │   Container B   │ │
│ │   (nginx)   │ │   (log agent)   │ │
│ └─────────────┘ └─────────────────┘ │
│        │               │            │
│        └───────┬───────┘            │
│            Shared Network           │
│            Shared Volumes           │
└─────────────────────────────────────┘
```

## Basic Pod Specification

### Minimal Pod Definition

**File: simple-pod.yaml**
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod
  labels:
    app: nginx
spec:
  containers:
  - name: nginx
    image: nginx:1.21
    ports:
    - containerPort: 80
```

```bash
# Deploy the pod
kubectl apply -f simple-pod.yaml

# Check pod status
kubectl get pods
kubectl get pod nginx-pod -o wide

# Describe the pod
kubectl describe pod nginx-pod
```

### Pod Lifecycle States

```
Pending → Running → Succeeded/Failed
   ↓         ↓           ↓
Creating  Executing   Completed
```

**Pod Phases:**
- **Pending**: Pod accepted but not yet scheduled/started
- **Running**: Pod bound to node, at least one container running
- **Succeeded**: All containers terminated successfully
- **Failed**: All containers terminated, at least one failed
- **Unknown**: Pod state cannot be determined

## Container Specifications

### Resource Requirements

**File: resource-pod.yaml**
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: resource-demo
spec:
  containers:
  - name: app
    image: nginx:1.21
    resources:
      requests:        # Minimum guaranteed resources
        memory: "64Mi"
        cpu: "250m"    # 250 millicores = 0.25 CPU
      limits:          # Maximum allowed resources
        memory: "128Mi"
        cpu: "500m"    # 500 millicores = 0.5 CPU
    ports:
    - containerPort: 80
```

**Resource Units:**
- **CPU**: `1` = 1 vCPU, `500m` = 0.5 vCPU, `100m` = 0.1 vCPU
- **Memory**: `128Mi` = 128 MiB, `1Gi` = 1 GiB, `1000M` = 1000 MB

### Environment Variables

**File: env-pod.yaml**
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: env-demo
spec:
  containers:
  - name: app
    image: nginx:1.21
    env:
    - name: DATABASE_URL
      value: "postgresql://localhost:5432/mydb"
    - name: API_KEY
      value: "secret-api-key"
    - name: NODE_NAME
      valueFrom:
        fieldRef:
          fieldPath: spec.nodeName
    - name: POD_IP
      valueFrom:
        fieldRef:
          fieldPath: status.podIP
```

### Volume Mounts

**File: volume-pod.yaml**
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: volume-demo
spec:
  containers:
  - name: app
    image: nginx:1.21
    volumeMounts:
    - name: html-volume
      mountPath: /usr/share/nginx/html
    - name: config-volume
      mountPath: /etc/nginx/conf.d
  volumes:
  - name: html-volume
    emptyDir: {}
  - name: config-volume
    configMap:
      name: nginx-config
```

## Multi-Container Pods

### Sidecar Pattern

**File: sidecar-pod.yaml**
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: sidecar-demo
spec:
  containers:
  # Main application container
  - name: web-app
    image: nginx:1.21
    ports:
    - containerPort: 80
    volumeMounts:
    - name: shared-logs
      mountPath: /var/log/nginx
  
  # Sidecar container for log processing
  - name: log-processor
    image: busybox:1.35
    command: ['sh', '-c']
    args:
    - while true; do
        echo "Processing logs at $(date)" >> /var/log/app/processed.log;
        sleep 30;
      done
    volumeMounts:
    - name: shared-logs
      mountPath: /var/log/app
  
  volumes:
  - name: shared-logs
    emptyDir: {}
```

### Init Containers

**File: init-pod.yaml**
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: init-demo
spec:
  initContainers:
  # Init container 1: Download configuration
  - name: download-config
    image: busybox:1.35
    command: ['sh', '-c']
    args:
    - echo "Downloading config...";
      sleep 5;
      echo "config-data" > /shared/config.txt;
      echo "Config downloaded"
    volumeMounts:
    - name: shared-data
      mountPath: /shared
  
  # Init container 2: Validate environment
  - name: validate-env
    image: busybox:1.35
    command: ['sh', '-c']
    args:
    - echo "Validating environment...";
      if [ -f /shared/config.txt ]; then
        echo "Config file found, validation passed";
      else
        echo "Config file missing, validation failed";
        exit 1;
      fi
    volumeMounts:
    - name: shared-data
      mountPath: /shared
  
  containers:
  # Main application container
  - name: app
    image: nginx:1.21
    volumeMounts:
    - name: shared-data
      mountPath: /usr/share/nginx/html
  
  volumes:
  - name: shared-data
    emptyDir: {}
```

## Pod Networking

### Pod-to-Pod Communication

```yaml
# Pod A
apiVersion: v1
kind: Pod
metadata:
  name: pod-a
  labels:
    app: client
spec:
  containers:
  - name: client
    image: busybox:1.35
    command: ['sleep', '3600']

---
# Pod B  
apiVersion: v1
kind: Pod
metadata:
  name: pod-b
  labels:
    app: server
spec:
  containers:
  - name: server
    image: nginx:1.21
    ports:
    - containerPort: 80
```

```bash
# Deploy both pods
kubectl apply -f pod-networking.yaml

# Get pod IPs
kubectl get pods -o wide

# Test connectivity from pod-a to pod-b
kubectl exec -it pod-a -- wget -qO- http://<pod-b-ip>
```

### Service Discovery

```yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  selector:
    app: server
  ports:
  - port: 80
    targetPort: 80
```

```bash
# Create service
kubectl apply -f service.yaml

# Test service discovery
kubectl exec -it pod-a -- nslookup nginx-service
kubectl exec -it pod-a -- wget -qO- http://nginx-service
```

## Pod Security

### Security Context

**File: security-pod.yaml**
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: security-demo
spec:
  securityContext:
    runAsUser: 1000      # Run as non-root user
    runAsGroup: 3000     # Primary group
    fsGroup: 2000        # Volume ownership group
  containers:
  - name: app
    image: nginx:1.21
    securityContext:
      allowPrivilegeEscalation: false
      readOnlyRootFilesystem: true
      runAsNonRoot: true
      capabilities:
        drop:
        - ALL
        add:
        - NET_BIND_SERVICE
    volumeMounts:
    - name: tmp-volume
      mountPath: /tmp
    - name: var-cache
      mountPath: /var/cache/nginx
    - name: var-run
      mountPath: /var/run
  volumes:
  - name: tmp-volume
    emptyDir: {}
  - name: var-cache
    emptyDir: {}
  - name: var-run
    emptyDir: {}
```

### Pod Security Standards

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: secure-namespace
  labels:
    pod-security.kubernetes.io/enforce: restricted
    pod-security.kubernetes.io/audit: restricted
    pod-security.kubernetes.io/warn: restricted
```

## Health Checks

### Liveness and Readiness Probes

**File: health-pod.yaml**
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: health-demo
spec:
  containers:
  - name: app
    image: nginx:1.21
    ports:
    - containerPort: 80
    
    # Liveness probe - restart container if fails
    livenessProbe:
      httpGet:
        path: /
        port: 80
      initialDelaySeconds: 30
      periodSeconds: 10
      timeoutSeconds: 5
      failureThreshold: 3
    
    # Readiness probe - remove from service if fails
    readinessProbe:
      httpGet:
        path: /
        port: 80
      initialDelaySeconds: 5
      periodSeconds: 5
      timeoutSeconds: 3
      successThreshold: 1
      failureThreshold: 3
    
    # Startup probe - for slow-starting containers
    startupProbe:
      httpGet:
        path: /
        port: 80
      initialDelaySeconds: 10
      periodSeconds: 10
      timeoutSeconds: 5
      failureThreshold: 30
```

### Probe Types

```yaml
# HTTP probe
livenessProbe:
  httpGet:
    path: /health
    port: 8080
    httpHeaders:
    - name: Custom-Header
      value: Awesome

# TCP probe
livenessProbe:
  tcpSocket:
    port: 8080

# Command probe
livenessProbe:
  exec:
    command:
    - cat
    - /tmp/healthy
```

## Pod Patterns

### Ambassador Pattern

**File: ambassador-pod.yaml**
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: ambassador-demo
spec:
  containers:
  # Main application
  - name: app
    image: nginx:1.21
    ports:
    - containerPort: 80
  
  # Ambassador proxy
  - name: ambassador
    image: envoyproxy/envoy:v1.24-latest
    ports:
    - containerPort: 8080
    volumeMounts:
    - name: envoy-config
      mountPath: /etc/envoy
  
  volumes:
  - name: envoy-config
    configMap:
      name: envoy-config
```

### Adapter Pattern

**File: adapter-pod.yaml**
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: adapter-demo
spec:
  containers:
  # Legacy application with custom log format
  - name: legacy-app
    image: busybox:1.35
    command: ['sh', '-c']
    args:
    - while true; do
        echo "$(date): LEGACY_LOG: Some application event" >> /var/log/app.log;
        sleep 10;
      done
    volumeMounts:
    - name: log-volume
      mountPath: /var/log
  
  # Adapter to convert log format
  - name: log-adapter
    image: busybox:1.35
    command: ['sh', '-c']
    args:
    - while true; do
        if [ -f /var/log/app.log ]; then
          tail -f /var/log/app.log | sed 's/LEGACY_LOG:/JSON:/' > /var/log/formatted.log;
        fi;
        sleep 5;
      done
    volumeMounts:
    - name: log-volume
      mountPath: /var/log
  
  volumes:
  - name: log-volume
    emptyDir: {}
```

## Pod Management Commands

### Basic Operations

```bash
# Create pod
kubectl apply -f pod.yaml
kubectl run nginx --image=nginx:1.21 --port=80

# List pods
kubectl get pods
kubectl get pods -o wide
kubectl get pods --show-labels
kubectl get pods -l app=nginx

# Describe pod
kubectl describe pod nginx-pod

# View logs
kubectl logs nginx-pod
kubectl logs nginx-pod -c container-name  # Multi-container pod
kubectl logs nginx-pod --previous         # Previous container instance
kubectl logs -f nginx-pod                 # Follow logs

# Execute commands
kubectl exec nginx-pod -- ls /
kubectl exec -it nginx-pod -- /bin/bash

# Port forwarding
kubectl port-forward nginx-pod 8080:80

# Copy files
kubectl cp nginx-pod:/etc/nginx/nginx.conf ./nginx.conf
kubectl cp ./index.html nginx-pod:/usr/share/nginx/html/

# Delete pod
kubectl delete pod nginx-pod
kubectl delete -f pod.yaml
```

### Debugging Commands

```bash
# Check pod events
kubectl get events --field-selector involvedObject.name=nginx-pod

# Check resource usage
kubectl top pod nginx-pod

# Debug networking
kubectl exec -it nginx-pod -- nslookup kubernetes.default
kubectl exec -it nginx-pod -- netstat -tulpn

# Check mounted volumes
kubectl exec -it nginx-pod -- df -h
kubectl exec -it nginx-pod -- mount | grep /usr/share/nginx/html
```

## Troubleshooting Common Issues

### Pod Stuck in Pending

```bash
# Check node resources
kubectl describe nodes
kubectl top nodes

# Check pod events
kubectl describe pod <pod-name>

# Check scheduler logs
kubectl logs -n kube-system -l component=kube-scheduler
```

### Pod Stuck in ContainerCreating

```bash
# Check pod events
kubectl describe pod <pod-name>

# Common causes:
# - Image pull issues
# - Volume mount problems
# - Resource constraints
# - Network issues
```

### Pod CrashLoopBackOff

```bash
# Check container logs
kubectl logs <pod-name> --previous

# Check liveness probe configuration
kubectl describe pod <pod-name>

# Debug with different image
kubectl run debug --image=busybox:1.35 --rm -it -- sh
```

## Best Practices

### Resource Management
- Always set resource requests and limits
- Use appropriate CPU and memory values
- Monitor resource usage with metrics

### Security
- Run containers as non-root users
- Use read-only root filesystems when possible
- Drop unnecessary capabilities
- Implement proper health checks

### Observability
- Include proper labels for organization
- Implement comprehensive health checks
- Use structured logging
- Monitor resource usage

## Practice Exercises

1. **Multi-Container Pod**: Create a pod with nginx and a log processor
2. **Health Checks**: Implement all three probe types
3. **Resource Limits**: Create pods with different resource constraints
4. **Init Containers**: Build a pod that downloads configuration before starting

## Key Takeaways

- **Pods are ephemeral** - treat them as cattle, not pets
- **One process per container** - follow Unix philosophy
- **Shared networking and storage** within pods
- **Health checks are critical** for reliability
- **Resource limits prevent** resource starvation
- **Security context** controls container privileges

---

**Next Module**: [Services and Networking](05-services.md)
