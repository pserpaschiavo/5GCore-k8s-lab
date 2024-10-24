# HNC_VERSION=v1.1.0
# HNC_VARIANT=default
GOPATH=/home/ubuntu/go

# setup-open5gs:
# 	@helm install open5gs oci://registry-1.docker.io/gradiant/open5gs \
# 		--namespace core5g \
#   		--create-namespace \
# 		--version 2.2.0 \
# 		--values https://gradiant.github.io/5g-charts/docs/open5gs-ueransim-gnb/5gSA-values.yaml

# setup-ueransim:
# 	@helm install ueransim-gnb oci://registry-1.docker.io/gradiant/ueransim-gnb \
# 	--namespace core5g \
# 	--create-namespace \
# 	--version 0.2.6 \
# 	--values https://gradiant.github.io/5g-charts/docs/open5gs-ueransim-gnb/gnb-ues-values.yaml \


setup-calico: 
	@kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.28.1/manifests/tigera-operator.yaml
	@kubectl apply -f kubernetes/calico/custom-resources.yaml

setup-flannel:
	@kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml

setup-multus:
	@kubectl apply -f https://raw.githubusercontent.com/k8snetworkplumbingwg/multus-cni/master/deployments/multus-daemonset-thick.yml

remove-multus:
	@kubectl delete -f https://raw.githubusercontent.com/k8snetworkplumbingwg/multus-cni/master/deployments/multus-daemonset-thick.yml

setup-ovs:
	@kubectl apply -f https://github.com/kubevirt/cluster-network-addons-operator/releases/download/v0.89.1/namespace.yaml
	@kubectl apply -f https://github.com/kubevirt/cluster-network-addons-operator/releases/download/v0.89.1/network-addons-config.crd.yaml 
	@kubectl apply -f https://github.com/kubevirt/cluster-network-addons-operator/releases/download/v0.89.1/operator.yaml
	@kubectl apply -f https://gist.githubusercontent.com/niloysh/1f14c473ebc08a18c4b520a868042026/raw/d96f07e241bb18d2f3863423a375510a395be253/network-addons-config.yaml

setup-ebs:
	@helm repo add openebs https://openebs.github.io/charts
	@helm repo update
	@helm upgrade --install openebs --namespace openebs openebs/openebs --create-namespace
	@kubectl patch storageclass openebs-hostpath -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'

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
	@helm install prometheus-stack prometheus-community/kube-prometheus-stack --version 62.0.0 \
  		--namespace monitoring \
  		--create-namespace \
		--values kubernetes/prometheus/values.yaml

setup-hnc:
	@kubectl apply -f https://github.com/kubernetes-sigs/hierarchical-namespaces/releases/download/$(HNC_VERSION)/$(HNC_VARIANT).yaml

setup-vcluster:
	@curl -L -o vcluster "https://github.com/loft-sh/vcluster/releases/download/v0.20.0-beta.12/vcluster-linux-amd64"
	@sudo install -c -m 0755 vcluster /usr/local/bin && rm -f vcluster
