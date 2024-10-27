#!/bin/bash

# Downloading Istio install binaries and files:
## https://istio.io/latest/docs/ambient/install/istioctl/
## https://istio.io/latest/docs/setup/additional-setup/download-istio-release/

## curl -L https://istio.io/downloadIstio | sh -
## curl -L https://istio.io/downloadIstio | ISTIO_VERSION=1.23.2 TARGET_ARCH=x86_64 sh -

curl -L https://istio.io/downloadIstio | ISTIO_VERSION=1.23.2 sh -
cd istio-1.23.2
export PATH=$PWD/bin:$PATH

## Installing Istio with demo profileÖ
istioctl install --set profile=demo --skip-confirmation

## Add a namespace label to instruct Istio to automatically inject Envoy sidecar proxies when you deploy your application later:
kubectl label namespace default istio-injection=enabled


# Install the Kubernetes Gateway API CRDs
## https://istio.io/latest/docs/setup/getting-started/#gateway-api
kubectl get crd gateways.gateway.networking.k8s.io &> /dev/null || \
{ kubectl kustomize "github.com/kubernetes-sigs/gateway-api/config/crd?ref=v1.1.0" | kubectl apply -f -; }


# Deploy the sample application
cd $HOME/istio-1.23.2/
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.23/samples/bookinfo/platform/kube/bookinfo.yaml
sleep 6m
kubectl get svc
kubectl get po
### wait for Pods to start and becomes healthy


# Open the application to outside traffic
kubectl apply -f samples/bookinfo/gateway-api/bookinfo-gateway.yaml
kubectl annotate gateway bookinfo-gateway networking.istio.io/service-type=ClusterIP --namespace=default
kubectl get gateway

## Test app with curl after port forward:
# kubectl port-forward svc/bookinfo-gateway-istio 8080:80
# curl http://localhost:8080/productpage
