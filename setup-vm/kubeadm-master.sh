#!/bin/bash

sudo apt-get update
# apt-transport-https may be a dummy package; if so, you can skip that package

# install packages needed to use the Kubernetes apt repository
echo "Get packages to use the k8s apt repository"

sudo apt-get install -y apt-transport-https ca-certificates curl gpg

curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.31/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo "Done!"


# This overwrites any existing configuration in /etc/apt/sources.list.d/kubernetes.list

echo "Overwriting any configuration in /etc/apt/sources.list.d/kubernetes.list"

echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.31/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

echo "Done!"

echo "Updating apt package index, installing kubelet, kubeadm and kubectl and hold them"

sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
sudo systemctl enable --now kubelet

echo "Done!"

# kubeadm init --apiserver-advertise-address=172.89.0.11 --pod-network-cidr=192.168.0.0/16 
kubeadm init --apiserver-advertise-address=172.89.0.11 --pod-network-cidr=10.244.0.0/16

cp /etc/kubernetes/admin.conf /mnt/.kube/config

kubeadm token create --print-join-command > /tmp/.cluster-join/token
