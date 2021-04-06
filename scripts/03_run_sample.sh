#!/bin/bash
set -e
source ./env.sh

echo KO_DOCKER_REPO=${KO_DOCKER_REPO}

cd ${HOME}/git/app-framework/samples/opinion-server
ko apply -f server.yaml
kubectl create -f workload.yaml
