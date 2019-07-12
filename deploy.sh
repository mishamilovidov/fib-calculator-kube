# build and tag images
docker build \
  -t mishamilovidov/multi-client:latest \
  -t mishamilovidov/multi-client:$SHA \
  -f ./client/Dockerfile ./client

docker build \
  -t mishamilovidov/multi-server:latest \
  -t mishamilovidov/multi-server:$SHA \
  -f ./server/Dockerfile ./server

docker build \
  -t mishamilovidov/multi-worker:latest \
  -t mishamilovidov/multi-worker:$SHA \
  -f ./worker/Dockerfile ./worker


# push built images to registry
docker push mishamilovidov/multi-client:latest
docker push mishamilovidov/multi-client:$SHA

docker push mishamilovidov/multi-server:latest
docker push mishamilovidov/multi-server:$SHA

docker push mishamilovidov/multi-worker:latest
docker push mishamilovidov/multi-worker:$SHA

# apply configs to k8s cluster
kubectl apply -f k8s

# set images for k8s deployment objects
kubectl set image deployments/client-deployment client=mishamilovidov/multi-client:$SHA
kubectl set image deployments/server-deployment server=mishamilovidov/multi-server:$SHA
kubectl set image deployments/worker-deployment worker=mishamilovidov/multi-worker:$SHA