aws ecr get-login-password --region ${REGION} | docker login --username AWS --password-stdin ${ECR_REGISTRY_ID}.dkr.ecr.ap-southeast-2.amazonaws.com
docker tag default-image ${ECR_URL}:latest
docker push ${ECR_URL}:latest