# Ping Pong API

## Endpoints
- /ping - Responds with {'pong'}
- /pong - Responds with {'ping'}
- /professional-ping-pong - Responds with {'pong'} 90% of the time
- /amateur-ping-pong - Responds with {'pong'} 70% of the time
- /chance-ping-pong - Responds with {'ping'} 50% of the time and {'pong'} 50% of the time

## Description
This is a simple API to test that the RapidAPI/Mashape API Proxy is working. When you access /ping, the API will return a JSON that contains "pong"

## Test Endpoints
API is live at https://rapidapi.com/user/RapidAlex/package/ping-pong

## Build

`buildah tag localhost/pingpong-api hubname/pingpong-api:latest`  
`buildah push hubname/pingpong-api:latest docker://docker.io/hubname/pingpong-api:latest`

## Deploy

`kubectl apply -f helm/app.yml`

## Use

After deplying the application to k8s, you can access `http://[IP]/ping`

## ToDos:

- Replace app.yml with helm chart
- Support HTTPS ingress (involved cert-manager and traefik)