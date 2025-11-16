# Envoy Gateway Setup Guide

## Prerequisites
- Kubernetes cluster (kubeadm based)
- MetalLB configured and running
- kubectl configured

## Installation Steps

### Step 1 — Install Envoy Gateway
```bash
kubectl apply -f https://github.com/envoyproxy/gateway/releases/latest/download/install.yaml
```

In case facing error you can use below command for Installing envoy gateway:
```bash
kubectl apply --server-side -f https://github.com/envoyproxy/gateway/releases/latest/download/install.yaml --force-conflicts
```

### Step 2 — Install Gateway API CRDs
```bash
kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/latest/download/standard-install.yaml
```

### Step 3 — Create GatewayClass (CRITICAL)
**This step is required** - without it, the Gateway will remain in "Unknown" state.

```bash
kubectl apply -f k8s/gateway/gatewayclass.yml
```

Verify GatewayClass is accepted:
```bash
kubectl get gatewayclass
# Should show: envoy-gateway-class   gateway.envoyproxy.io/gatewayclass-controller   True
```

### Step 4 — Apply Gateway and Routes
```bash
kubectl apply -f k8s/gateway/gateway.yml
kubectl apply -f k8s/gateway/route.yml
kubectl apply -f k8s/gateway/route-preview.yml
```

## Verification

### Check Gateway Status
```bash
kubectl get gateway -n dev-blue-green-deployment
# Should show ADDRESS and PROGRAMMED=True
```

### Check HTTPRoutes
```bash
kubectl get httproute -n dev-blue-green-deployment
```

### Get Gateway IP Address
```bash
kubectl get gateway eg -n dev-blue-green-deployment -o jsonpath='{.status.addresses[0].value}'
# Returns: 192.168.1.224 (assigned by MetalLB)
```

### Check Envoy Proxy Service
```bash
kubectl get svc -n envoy-gateway-system | grep envoy-dev
# Shows LoadBalancer service with MetalLB IP
```

## Accessing Applications

**Gateway IP:** 192.168.1.224

### From within the cluster:
```bash
# Active/Production route
curl http://192.168.1.224/

# Preview route
curl http://192.168.1.224/preview
```

### From external network:
Access via any node that can reach the MetalLB IP range:
- **Production App:** http://192.168.1.224/
- **Preview App:** http://192.168.1.224/preview

## Architecture

```
[Client] 
    |
    v
[MetalLB: 192.168.1.224]
    |
    v
[Envoy Gateway Service]
    |
    v
[Envoy Proxy Pod]
    |
    +---> [HTTPRoute: /] ---> [hello-world-app-svc:80]
    |
    +---> [HTTPRoute: /preview] ---> [hello-world-app-preview-svc:80]
```

## Troubleshooting

### Issue: Gateway shows "Unknown" status
**Cause:** GatewayClass is missing
**Solution:** Apply gatewayclass.yml (see Step 3)

### Issue: Gateway has no ADDRESS
**Cause:** Either GatewayClass is missing or MetalLB is not configured
**Solution:** 
1. Verify GatewayClass exists and is accepted
2. Check MetalLB IP pool has available addresses

### Issue: Routes not working
**Checks:**
```bash
# Check backend services exist
kubectl get svc -n dev-blue-green-deployment

# Check endpoints are available
kubectl get endpoints -n dev-blue-green-deployment

# Check HTTPRoute status
kubectl describe httproute webapp-active-route -n dev-blue-green-deployment

# Check Envoy proxy logs
kubectl logs -n envoy-gateway-system -l gateway.envoyproxy.io/owning-gateway-name=eg
```

### View Envoy Gateway Controller Logs
```bash
kubectl logs -n envoy-gateway-system -l control-plane=envoy-gateway
```

## Current Status

✅ **Gateway:** Programmed and ready
✅ **IP Address:** 192.168.1.224 (assigned by MetalLB)
✅ **Routes:** 2 routes attached (active + preview)
✅ **Backend Services:** hello-world-app-svc and hello-world-app-preview-svc
✅ **Envoy Proxy:** Running with 2/2 containers

## File Structure

```
k8s/gateway/
├── gatewayclass.yml      # Defines the GatewayClass for Envoy
├── gateway.yml           # Main Gateway resource
├── route.yml             # HTTPRoute for active/production (path: /)
└── route-preview.yml     # HTTPRoute for preview (path: /preview)
```

## Notes

- The Gateway uses the `envoy-gateway-class` GatewayClass
- MetalLB automatically assigns an IP from the configured pool
- Routes are in the same namespace as the Gateway (dev-blue-green-deployment)
- Both services point to the same endpoint (10.1.1.224:80) - likely using Argo Rollouts for blue-green deployment

