# Roadmap

1. Implement Argo Rollouts with Blue/Green :- Done
2. Implement Argo Rollouts with Canary :- Yet to do
3. Implement Gateway Routing along with Envoy :-  Yet to do
4. Terraform with altanis for resource :- Yet to do
5. Multi Cloud Deployment :- Yet to Do


docker build --build-arg ENV_TYPE=blue -t nginx-blue .

docker build --build-arg ENV_TYPE=green -t nginx-green .


docker buildx build --platform linux/amd64,linux/arm64 --build-arg ENV_TYPE=blue -t nginx-blue .

docker buildx build --platform linux/amd64,linux/arm64 --build-arg ENV_TYPE=green -t nginx-green .



# Login to Docker Hub
docker login

# Build and push blue version
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  --build-arg ENV_TYPE=blue \
  -t abhilashshettigar/poc:nginx-blue-latest \
  -t abhilashshettigar/poc:nginx-blue-2.0 \
  --push \
  .

# Build and push green version
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  --build-arg ENV_TYPE=green \
  -t abhilashshettigar/poc:nginx-green-latest \
  -t abhilashshettigar/poc:nginx-green-1.0 \
  --push \
  .


  abhilashshettigar/poc:nginx-green-latest
  abhilashshettigar/poc:nginx-blue-latest


  ```kubectl argo rollouts set image webapp webapp=your-image:v2```

  ```kubectl argo rollouts get rollout webapp```
  ```kubectl argo rollouts promote webapp```


  ```kubectl argo rollouts set image hello-world-app webapp=abhilashshettigar/poc:nginx-blue-2.0 -n dev-blue-green-deployment && kubectl argo rollouts promote hello-world-app -n dev-blue-green-deployment```

  