# Ping Pong API

## Endpoints
- /ping - Responds with {'pong'}
- /pong - Responds with {'ping'}
- /professional-ping-pong - Responds with {'pong'} 90% of the time
- /amateur-ping-pong - Responds with {'pong'} 70% of the time
- /chance-ping-pong - Responds with {'ping'} 50% of the time and {'pong'} 50% of the time

## Description
This is a simple API to test that the RapidAPI/Mashape API Proxy is working. When you access /ping, the API will return a JSON that contains "pong"

The deployment includes at least teh following:
- Dockerfile
- GitHub Actions pipeline that performs tests, builds the docker image and pushes it to ECR
- Helm chart for deployment to k8s
- Ingress for accessing the API via a domain name
- Terraform for deploying the EKS cluster

## Test Endpoints
API is live at https://rapidapi.com/user/RapidAlex/package/ping-pong

## Build

`docker tag localhost/pingpong-api $ECR_REGISTRY/pingpong-api:latest`  
`docker push $ECR_REGISTRY/pingpong-api:latest`

## Deploy

Automatically via the github pipeline, or via

```
helm upgrade --install ping-pong-api $HELM_CHART_PATH \
          --set image.repository=$ECR_REGISTRY/$ECR_REPOSITORY \
          --set image.tag=$IMAGE_TAG \
          --set ingress.hosts[0].host=ping-pong-${IMAGE_TAG::7}.biconomy.io \
          --wait \
          --timeout=10m
```

## Use

After deplying the application to k8s, you can access `https://ping-pong-${IMAGE_TAG::7}.biconomy.io/ping`
