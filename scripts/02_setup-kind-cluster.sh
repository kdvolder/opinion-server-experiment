#!/bin/bash
set -e
source ./env.sh
echo WORKLOAD_NS=${WORKLOAD_NS}
git_dir=${HOME}/git

cd $git_dir
if [ -d app-framework ] ; then
    cd app-framework
#    git pull
else
    git clone git@gitlab.eng.vmware.com:dap-app-stack/app-framework.git
    cd app-framework
fi

kind delete cluster
kind create cluster
kubectl create ns ${WORKLOAD_NS}
kapp -y deploy -n kube-system -a cert-manager -f dist/third-party/cert-manager.yaml

kapp -y deploy -n kube-system -a opinion-service -f <(ko resolve -f dist/opinion-service.yaml)
