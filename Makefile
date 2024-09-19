HNC_VERSION=v1.1.0
HNC_VARIANT=default
GOPATH=/home/ubuntu/go

setup-calico: 
	@kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.28.1/manifests/tigera-operator.yaml
	@kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.28.1/manifests/custom-resources.yaml

setup-flannel:
	@kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml

setup-multus:
	@kubectl apply -f https://raw.githubusercontent.com/k8snetworkplumbingwg/multus-cni/master/deployments/multus-daemonset-thick.yml

untain-nodes:
	@kubectl taint nodes --all node-role.kubernetes.io/control-plane-
	@kubectl taint nodes --all node-role.kubernetes.io/master-

setup-free5gc:

setup-metallb:
	@kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.14.8/config/manifests/metallb-native.yaml


setup-cert-manager:
	@helm repo add jetstack https://charts.jetstack.io
	@helm repo update
	@helm upgrade --install cert-manager jetstack/cert-manager \
  		--namespace cert-manager \
  		--create-namespace \
  		--set crds.enabled=true

setup-prometheus:
	@helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
	@helm repo update
	@helm install kube-prometheus-stack prometheus-community/kube-prometheus-stack --version 62.0.0 \
  		--namespace monitoring \
  		--create-namespace \
		--values kubernetes/prometheus/values.yaml

setup-hnc:
	@kubectl apply -f https://github.com/kubernetes-sigs/hierarchical-namespaces/releases/download/$(HNC_VERSION)/$(HNC_VARIANT).yaml

setup-vcluster:
	@curl -L -o vcluster "https://github.com/loft-sh/vcluster/releases/download/v0.20.0-beta.12/vcluster-linux-amd64"
	@sudo install -c -m 0755 vcluster /usr/local/bin && rm -f vcluster
