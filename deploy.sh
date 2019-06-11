#! /bin/sh

set -e
export DB_USER_PASS=`uuidgen`
export DB_USERNAME='postgres'
export DB_NAME='foreman'
export RAILS_SECRET=`uuidgen`

kubectl create namespace foreman

kubectl config set-context $(kubectl config current-context) --namespace=foreman

kubectl create secret generic db-user-pass --from-literal=password=${DB_USER_PASS}
kubectl create secret generic db-user --from-literal=username=${DB_USERNAME}
kubectl create secret generic db-url --from-literal=url=postgres://${DB_USERNAME}:${DB_USER_PASS}@postgres/${DB_NAME}?pool=5 
kubectl create secret generic secret-key-base --from-literal=secret-key-base=${RAILS_SECRET}

kubectl create -f volumes/postgres_volumes.yaml
kubectl create -f services/postgres_svc.yaml
kubectl create -f services/redis_svc.yaml
kubectl create -f services/rails_svc.yaml
kubectl create -f deployments/postgres_deploy.yaml
kubectl create -f deployments/redis_deploy.yaml
kubectl create -f jobs/setup.yaml
kubectl create -f deployments/rails_deploy.yaml
kubectl create -f deployments/worker_deploy.yaml
kubectl create -f ingresses/ingress.yaml
kubectl create -f web-autoscaler.yml
