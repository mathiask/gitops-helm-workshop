#!/bin/bash

# This script assumes that helm, flux, linkerd, and flagger are already installed.
# Its purpose is to set up a cluster again from scratch after trashing it.

. setup.sh

# Flux
echo Flux...
helm repo add fluxcd https://charts.fluxcd.io
kubectl create ns fluxcd

helm upgrade -i flux fluxcd/flux --wait \
--namespace fluxcd \
--set registry.pollInterval=1m \
--set git.pollInterval=1m \
--set git.url=git@github.com:${GHUSER}/gitops-helm-workshop

fluxctl identity
echo Add this as a a key to the github repo!
echo ...flux done.

# Helm Operator
echo Helm...

helm upgrade -i helm-operator fluxcd/helm-operator --wait \
--namespace fluxcd \
--set git.ssh.secretName=flux-git-deploy \
--set git.pollInterval=1m \
--set chartsSyncInterval=1m \
--set helm.versions=v3

echo ...helm done.

# Linkerd
echo Linkerd...
linkerd install | kubectl apply -f -
linkerd check
echo ...linkerd done.

# Flagger
echo Flagger...
kubectl apply -f https://raw.githubusercontent.com/weaveworks/flagger/master/artifacts/flagger/crd.yaml

helm upgrade -i flagger flagger/flagger --wait \
--namespace linkerd \
--set crd.create=false \
--set metricsServer=http://linkerd-prometheus:9090 \
--set meshProvider=linkerd

echo ...flagger done.

echo Now you can run "fluxcd sync"
