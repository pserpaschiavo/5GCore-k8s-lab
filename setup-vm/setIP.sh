#!/bin/bash

export IP=$(ip addr show enp0s8 | awk '/inet / {print $2}' | cut -d'/' -f1 | head -n 1)
echo "KUBELET_EXTRA_ARGS=--node-ip=$IP" > /etc/default/kubelet
systemctl daemon-reload
systemctl restart kubelet
