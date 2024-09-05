#!/usr/bin/env bash

clusterConfigsFolder="/clusterConfigs"

echo "Installing curl..."
apt update
apt install -y curl

echo "Installing K3s..."
wget -q -O - https://get.k3s.io | \
	INSTALL_K3S_EXEC="server - no-deploy traefik" \
	K3S_KUBECONFIG_MODE="644" \
	sh -s - \
	--flannel-iface "eth1"

if [ $? == 0 ] ; then
   echo "K3s successfully installed"
else
   echo "K3s installation has been failed"
fi

echo "Applying deployments and services..."
kubectl apply -f $clusterConfigsFolder/app-one.yml
kubectl apply -f $clusterConfigsFolder/app-two.yml
kubectl apply -f $clusterConfigsFolder/app-three.yml

echo "Installing NGINX Ingress Controller"
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.11.2/deploy/static/provider/cloud/deploy.yaml

echo "Disabling the validation webhook..."
kubectl apply -f $clusterConfigsFolder/ingress-nginx-no-validation.yml

while ! kubectl get pods -n ingress-nginx | grep -q "Running"; do
    echo "Waiting for the NGINX Ingress Controller pod to be in Running state..."
    sleep 10
done

while ! kubectl get service ingress-nginx-controller-admission -n ingress-nginx | grep -q "443"; do
    echo "Waiting for the Ingress NGINX admission webhook service to be ready..."
    sleep 10
done

echo "Applying NGINX Ingress Controller configuration..."
kubectl apply -f $clusterConfigsFolder/ingress.yml

while ! kubectl get ingress | grep -q "192.168.56.110" ; do
    echo "Waiting for the Ingres Controller to be running and available to accept requests..."
    sleep 10
done
echo "Ingres Controller configured and ready to receive requests."
