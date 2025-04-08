#!/usr/bin/env bash

# Prerequisites:
# * kubectl 1.18+ points to a running K8s cluster
# * helm 3+
# * environment variables SLACK_CHANNEL and SLACK_API_URL are set

set -eo pipefail
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

GREEN='\033[0;32m'
ORANGE='\033[0;33m'
NO_COLOR='\033[0m'

printf "%bInstalling kube-prometheus-stack...%b\n" "$GREEN" "$NO_COLOR"
# helm search repo prometheus-community/kube-prometheus-stack
KUBE_PROMETHEUS_STACK_VERSION='70.4.0'
KUBE_PROMETHEUS_STACK_NAME='prometheus'
KUBE_PROMETHEUS_STACK_NAMESPACE='monitoring'
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm upgrade "$KUBE_PROMETHEUS_STACK_NAME" prometheus-community/kube-prometheus-stack \
  --version "$KUBE_PROMETHEUS_STACK_VERSION" \
  --install \
  --namespace "$KUBE_PROMETHEUS_STACK_NAMESPACE" \
  --create-namespace \
  --wait \
  --set "defaultRules.create=false" \
  --set "nodeExporter.enabled=false" \
  --set "prometheus.prometheusSpec.scrapeInterval=5s" \
  --set "prometheus.prometheusSpec.ruleSelectorNilUsesHelmValues=false" \
  --set "prometheus.prometheusSpec.podMonitorSelectorNilUsesHelmValues=false" \
  --set "prometheus.prometheusSpec.serviceMonitorSelectorNilUsesHelmValues=false" \
  --set "prometheus.prometheusSpec.probeSelectorNilUsesHelmValues=false" \
  --set "alertmanager.alertmanagerSpec.useExistingSecret=true" \
  --set "grafana.env.GF_INSTALL_PLUGINS=flant-statusmap-panel" \
  --set "grafana.adminPassword=admin"

printf "\n%bTo open Prometheus UI execute \nkubectl -n %s port-forward svc/%s-kube-prometheus-stack-prometheus 9090\nand open your browser at http://localhost:9090\n\n" "$GREEN" "$KUBE_PROMETHEUS_STACK_NAMESPACE" "$KUBE_PROMETHEUS_STACK_NAME"
printf "\n%bTo open Grafana UI execute \nkubectl -n %s port-forward svc/%s-grafana 3000:80\nand open your browser at http://localhost:3000\nusername: admin, password: admin%b\n" "$KUBE_PROMETHEUS_STACK_NAMESPACE" "$KUBE_PROMETHEUS_STACK_NAME" "$NO_COLOR"
