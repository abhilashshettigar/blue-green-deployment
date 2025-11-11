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
  -t abhilashshettigar/poc:nginx-blue-1.0 \
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