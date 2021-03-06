#!/bin/bash 
set -e
target=/usr/local/bin

# make sure golang is installed
if ! [ -x "$(command -v go)" ]; then
  echo 'Error: golang is not installed.' >&2
  exit 1
fi

if [ "$(uname)" == "Darwin" ]; then
  #get kapp
  curl -L https://github.com/vmware-tanzu/carvel-kapp/releases/download/v0.36.0/kapp-darwin-amd64 > ${target}/kapp
  chmod a+x ${target}/kapp

  #get imgpkg
  curl -L https://github.com/vmware-tanzu/carvel-imgpkg/releases/download/v0.5.0/imgpkg-darwin-amd64 > ${target}/imgpkg
  chmod a+x ${target}/imgpkg

  #get kbld
  curl -L https://github.com/vmware-tanzu/carvel-kbld/releases/download/v0.29.0/kbld-darwin-amd64 > ${target}/kbld
  chmod a+x ${target}/kbld

  #get ko
  curl -L https://github.com/google/ko/releases/download/v0.8.1/ko_0.8.1_Darwin_x86_64.tar.gz | tar xzf - ko 
  chmod +x ./ko
  mv ko ${target}/ko
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
  #get kapp
  curl -L https://github.com/vmware-tanzu/carvel-kapp/releases/download/v0.36.0/kapp-linux-amd64 > ${target}/kapp
  chmod a+x ${target}/kapp

  #get imgpkg
  curl -L https://github.com/vmware-tanzu/carvel-imgpkg/releases/download/v0.5.0/imgpkg-linux-amd64 > ${target}/imgpkg
  chmod a+x ${target}/imgpkg

  #get kbld
  curl -L https://github.com/vmware-tanzu/carvel-kbld/releases/download/v0.29.0/kbld-linux-amd64 > ${target}/kbld
  chmod a+x ${target}/kbld

  #get ko
  curl -L https://github.com/google/ko/releases/download/v0.8.1/ko_0.8.1_Linux_x86_64.tar.gz | tar xzf - ko 
  chmod +x ./ko
  mv ko ${target}/ko
else
   echo "Error. What OS is this???"
   exit 1
fi

#Check all that installed junk
echo "----------------------------------------------------------------------"
echo "----------------------------------------------------------------------"
echo "----------------------------------------------------------------------"
kapp --version | grep version
imgpkg --version | grep version
kbld --version | grep version
echo "ko version = $(ko version)"
go version