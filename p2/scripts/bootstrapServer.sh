#!/usr/bin/env bash

echo "Installing K3s..."
wget -q -O - https://get.k3s.io | \
	INSTALL_K3S_EXEC="server" \
	K3S_KUBECONFIG_MODE="644" \
	K3S_TOKEN="mypassword" \
	sh -s - \
	--flannel-backend none \
	--flannel-iface "eth1"

if [ $? == 0 ] ; then
   echo "K3s successfully installed"
else
   echo "K3s instalation has been failed"
fi