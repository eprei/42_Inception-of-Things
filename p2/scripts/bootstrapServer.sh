#!/usr/bin/env bash

clusterConfigsFolder="/clusterConfigs"

echo "Installing K3s..."
wget -q -O - https://get.k3s.io | \
	INSTALL_K3S_EXEC="server" \
	K3S_KUBECONFIG_MODE="644" \
	sh -s - \
	--flannel-iface "eth1"

if [ $? == 0 ] ; then
   echo "K3s successfully installed"
else
   echo "K3s installation has been failed"
fi

echo "Applying kube configurations..."
kubectl apply -f $clusterConfigsFolder/app-one.yml
kubectl apply -f $clusterConfigsFolder/app-two.yml
kubectl apply -f $clusterConfigsFolder/app-three.yml
kubectl apply -f $clusterConfigsFolder/ingress.yml
