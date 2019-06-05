#!/usr/bin/env bash

export CLUSTER_NAME=weavenet-cni-example

# create a ha k8s cluster with kind
kind create cluster --name=${CLUSTER_NAME} --config=config-ha-no-kindnet.yaml

# setup the kubeconfig
export KUBECONFIG="$(kind get kubeconfig-path --name="${CLUSTER_NAME}")"

# display cluster-info
kubectl cluster-info

# install weave
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"

# wait for nodes to be ready
kubectl wait --for=condition=Ready --timeout=30s \
	nodes/${CLUSTER_NAME}-control-plane \
	nodes/${CLUSTER_NAME}-control-plane2 \
	nodes/${CLUSTER_NAME}-control-plane3 \
	nodes/${CLUSTER_NAME}-worker \
	nodes/${CLUSTER_NAME}-worker2 \
	nodes/${CLUSTER_NAME}-worker3

# check the nodes
kubectl get nodes
