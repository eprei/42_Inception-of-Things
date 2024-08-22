#!/usr/bin/env bash

echo "Installing K3s..."
wget -q -O - https://get.k3s.io | sh -
if [ $? == 0 ] ; then
   echo "K3s successfully installed"
else
   echo "K3s instalation has been failed"
fi