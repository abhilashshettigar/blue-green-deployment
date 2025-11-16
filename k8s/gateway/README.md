# Envoy Gateway - Quick Reference

## Current Configuration

**Gateway IP:** 192.168.1.224 (MetalLB assigned)  
**Namespace:** dev-blue-green-deployment

## Apply All Resources

```bash
kubectl apply -f gateway/gatewayclass.yml
kubectl apply -f gateway/gateway.yml
kubectl apply -f gateway/route.yml
kubectl apply -f gateway/route-preview.yml
```

## Access Applications

- **Production:** http://192.168.1.224/
- **Preview:** http://192.168.1.224/preview

## Quick Status Check

```bash
# Gateway status
kubectl get gateway eg -n dev-blue-green-deployment

# Routes status
kubectl get httproute -n dev-blue-green-deployment

# Envoy proxy pod
kubectl get pods -n envoy-gateway-system | grep envoy-dev

# Services
kubectl get svc -n envoy-gateway-system | grep envoy-dev
```

## Troubleshooting

```bash
# Gateway details
kubectl describe gateway eg -n dev-blue-green-deployment

# Route details
kubectl describe httproute webapp-active-route -n dev-blue-green-deployment

# Envoy logs
kubectl logs -n envoy-gateway-system -l gateway.envoyproxy.io/owning-gateway-name=eg

# Controller logs
kubectl logs -n envoy-gateway-system -l control-plane=envoy-gateway
```

## Architecture

Routes → Gateway → Envoy Proxy → Backend Services
- `/` → hello-world-app-svc:80
- `/preview` → hello-world-app-preview-svc:80
