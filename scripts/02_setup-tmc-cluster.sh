#!/bin/bash
set -e
source ./env.sh
echo WORKLOAD_NS=${WORKLOAD_NS}
git_dir=${HOME}/git

# This assumes you keep a kube config file for your tmc cluster as ~/.kube/config-tmc
if [ ! -f ~/.kube/config-tmc ]; then
   echo "This script assumes you keep a kube config file for your tmc cluster as ~/.kube/config-tmc"
   exit -1
fi
cp ~/.kube/config-tmc ~/.kube/config
kubectl cluster-info

cd $git_dir
if [ -d app-framework ] ; then
    cd app-framework
    git pull
else
    git clone git@gitlab.eng.vmware.com:dap-app-stack/app-framework.git
    cd app-framework
fi

if kubectl get namespace ${WORKLOAD_NS}; then
    echo "Namespace ${WORKLOAD_NS} already exist!"
else
    kubectl create ns ${WORKLOAD_NS}
fi

if kubectl get clusterrolebinding privileged-cluster-role-binding ; then
    echo "privileged-cluster-role-binding already exists"
else 
    kubectl create clusterrolebinding privileged-cluster-role-binding \
        --clusterrole=vmware-system-tmc-psp-privileged \
        --group=system:authenticated
fi


kapp -y deploy -n kube-system -a cert-manager -f dist/third-party/cert-manager.yaml

kapp -y deploy -n kube-system -a opinion-service -f <(ko resolve -f dist/opinion-service.yaml)
