# Exercise 1: Your First Pod

## Objective
Create and deploy your first Kubernetes pod with a web application.

## Requirements
1. Create a pod running nginx web server
2. Configure resource limits and requests
3. Add environment variables
4. Expose the container port
5. Verify the pod is running and accessible

## Template
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-first-pod
  labels:
    # Add appropriate labels here
spec:
  containers:
  - name: # Container name
    image: # Container image
    ports:
    - containerPort: # Port number
    resources:
      requests:
        # Add resource requests
      limits:
        # Add resource limits
    env:
    - name: # Environment variable name
      value: # Environment variable value
```

## Step-by-Step Instructions

### 1. Create the Pod Manifest
Create a file called `my-first-pod.yaml` with:
- Pod name: `my-first-pod`
- Container image: `nginx:1.21`
- Container port: `80`
- Labels: `app: web`, `tier: frontend`
- Environment variable: `ENVIRONMENT=learning`
- Resource requests: `100m` CPU, `64Mi` memory
- Resource limits: `200m` CPU, `128Mi` memory

### 2. Deploy the Pod
```bash
# Apply the manifest
kubectl apply -f my-first-pod.yaml

# Verify pod is created
kubectl get pods

# Check pod details
kubectl describe pod my-first-pod
```

### 3. Test the Pod
```bash
# Check if pod is running
kubectl get pod my-first-pod -o wide

# View pod logs
kubectl logs my-first-pod

# Port forward to access the web server
kubectl port-forward my-first-pod 8080:80

# In another terminal, test the connection
curl http://localhost:8080
```

### 4. Explore the Pod
```bash
# Execute commands inside the pod
kubectl exec -it my-first-pod -- /bin/bash

# Inside the pod, run:
# - ps aux (see running processes)
# - env (see environment variables)
# - cat /etc/nginx/nginx.conf (view nginx config)
# - exit (to leave the pod)
```

### 5. Clean Up
```bash
# Delete the pod
kubectl delete pod my-first-pod

# Or delete using the manifest
kubectl delete -f my-first-pod.yaml
```

## Expected Output

When you run `kubectl get pods`, you should see:
```
NAME           READY   STATUS    RESTARTS   AGE
my-first-pod   1/1     Running   0          30s
```

When you access `http://localhost:8080`, you should see the nginx welcome page.

## Verification Checklist
- [ ] Pod is in `Running` state
- [ ] Container port 80 is exposed
- [ ] Resource limits are applied
- [ ] Environment variable is set
- [ ] Web server is accessible via port-forward
- [ ] Pod logs show nginx startup messages

## Troubleshooting

**Pod stuck in Pending:**
- Check node resources: `kubectl describe nodes`
- Check pod events: `kubectl describe pod my-first-pod`

**Pod stuck in ContainerCreating:**
- Check image pull status: `kubectl describe pod my-first-pod`
- Verify image name is correct

**Cannot access web server:**
- Verify port-forward command is correct
- Check if nginx is running: `kubectl logs my-first-pod`

## Bonus Challenges
1. Add a second container to the pod (busybox with sleep command)
2. Mount a volume to serve custom HTML content
3. Add health checks (liveness and readiness probes)
4. Use a different web server image (apache, caddy, etc.)

## Solution
Check `solutions/exercise01.yaml` after attempting the exercise.
