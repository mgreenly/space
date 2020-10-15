# Sample App

This just gives me a deployment that I can target with the alb

```
kubectl apply -f Deployment.yaml
kubectl get deployments
kubectl rollout status deployment.v1.apps/nginx-deployment
kubectl get rs
kubectl get pods --show-labels
kubectl --record deployment.apps/nginx-deployment set image deployment.v1.apps/nginx-deployment nginx=nginx:1.16.1
kubectl set image deployment/nginx-deployment nginx=nginx:1.16.1 --record
kubectl get pods
```
