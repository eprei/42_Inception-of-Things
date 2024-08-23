#!/usr/bin/env bash

echo "Installing K3s..."
wget -q -O - https://get.k3s.io | \
	INSTALL_K3S_EXEC="agent" \
	K3S_TOKEN="mypassword" \
	sh -s - \
	--flannel-iface 'eth1' \
	--server "https://192.168.56.110:6443"

if [ $? == 0 ] ; then
   echo "K3s successfully installed"
else
   echo "K3s installation has been failed"
fi