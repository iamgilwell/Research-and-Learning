# Exercise 2: Multi-Container Pod with Shared Storage

## Objective
Create a pod with multiple containers that share data through volumes.

## Requirements
1. Create a pod with two containers:
   - Web server (nginx)
   - Content generator (busybox)
2. Use shared volume for HTML content
3. Content generator creates/updates HTML files
4. Web server serves the generated content
5. Implement proper resource management

## Scenario
You need to build a dynamic web application where:
- A background process generates HTML content
- A web server serves this content to users
- Both containers share the same storage volume

## Template
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: shared-storage-pod
  labels:
    app: dynamic-web
spec:
  containers:
  # Web server container
  - name: web-server
    image: nginx:1.21
    # Configure ports, resources, volume mounts
    
  # Content generator container  
  - name: content-generator
    image: busybox:1.35
    # Configure command, resources, volume mounts
    
  volumes:
  # Define shared volume
```

## Detailed Requirements

### Web Server Container
- **Name**: `web-server`
- **Image**: `nginx:1.21`
- **Port**: `80`
- **Volume Mount**: `/usr/share/nginx/html` (nginx document root)
- **Resources**: 
  - Requests: `50m` CPU, `32Mi` memory
  - Limits: `100m` CPU, `64Mi` memory

### Content Generator Container
- **Name**: `content-generator`
- **Image**: `busybox:1.35`
- **Command**: Shell script that generates HTML content
- **Volume Mount**: `/var/www` (same volume as web server)
- **Resources**:
  - Requests: `25m` CPU, `16Mi` memory
  - Limits: `50m` CPU, `32Mi` memory

### Content Generation Script
The busybox container should run a script that:
1. Creates an `index.html` file with current timestamp
2. Creates a `status.html` file with pod information
3. Updates content every 30 seconds
4. Includes pod name, node name, and current time

## Step-by-Step Instructions

### 1. Create the Pod Manifest
```yaml
# Your implementation here
# Include both containers with proper configuration
```

### 2. Deploy and Test
```bash
# Deploy the pod
kubectl apply -f shared-storage-pod.yaml

# Wait for pod to be ready
kubectl wait --for=condition=Ready pod/shared-storage-pod --timeout=60s

# Check pod status
kubectl get pod shared-storage-pod -o wide
```

### 3. Verify Shared Storage
```bash
# Check web server container
kubectl exec shared-storage-pod -c web-server -- ls -la /usr/share/nginx/html

# Check content generator container
kubectl exec shared-storage-pod -c content-generator -- ls -la /var/www

# View generated content
kubectl exec shared-storage-pod -c web-server -- cat /usr/share/nginx/html/index.html
```

### 4. Test Web Access
```bash
# Port forward to access web server
kubectl port-forward shared-storage-pod 8080:80

# In another terminal, test the web server
curl http://localhost:8080
curl http://localhost:8080/status.html

# Watch content updates (run multiple times)
watch -n 5 curl -s http://localhost:8080/status.html
```

### 5. Monitor Container Logs
```bash
# View web server logs
kubectl logs shared-storage-pod -c web-server

# View content generator logs
kubectl logs shared-storage-pod -c content-generator -f

# View all container logs
kubectl logs shared-storage-pod --all-containers=true
```

## Expected Behavior

1. **Pod Status**: Both containers should be running
2. **Shared Files**: Both containers can see the same files
3. **Dynamic Content**: HTML content updates every 30 seconds
4. **Web Access**: Nginx serves the generated HTML files
5. **Resource Usage**: Containers stay within defined limits

## Sample Content Generator Script
```bash
#!/bin/sh
while true; do
  echo "<h1>Dynamic Content</h1>" > /var/www/index.html
  echo "<p>Generated at: $(date)</p>" >> /var/www/index.html
  echo "<p>Pod Name: $HOSTNAME</p>" >> /var/www/index.html
  
  echo "<h2>Pod Status</h2>" > /var/www/status.html
  echo "<p>Uptime: $(uptime)</p>" >> /var/www/status.html
  echo "<p>Last Update: $(date)</p>" >> /var/www/status.html
  
  sleep 30
done
```

## Verification Checklist
- [ ] Pod has two containers in Running state
- [ ] Shared volume is mounted in both containers
- [ ] Content generator creates HTML files
- [ ] Web server serves generated content
- [ ] Content updates automatically every 30 seconds
- [ ] Resource limits are respected
- [ ] Both containers can access shared files

## Troubleshooting

**Pod not starting:**
```bash
kubectl describe pod shared-storage-pod
kubectl get events --field-selector involvedObject.name=shared-storage-pod
```

**Containers can't see shared files:**
- Verify volume mount paths are correct
- Check volume definition in pod spec
- Ensure both containers mount the same volume

**Content not updating:**
- Check content generator logs
- Verify script syntax and permissions
- Ensure container has write access to volume

## Advanced Challenges
1. Add a third container that monitors log files
2. Use init containers to set up initial content
3. Implement health checks for both containers
4. Add resource monitoring and alerts
5. Use ConfigMap to customize the generation script

## Real-World Applications
This pattern is useful for:
- **Log Processing**: Sidecar containers processing application logs
- **Monitoring**: Metrics collection containers alongside applications
- **Proxy/Ambassador**: Service mesh sidecars
- **Content Management**: Dynamic content generation systems

## Solution
Check `solutions/exercise02.yaml` after attempting the exercise.
