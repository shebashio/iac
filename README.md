# Getting Started with Consul on Kubernetes

## 01 - Install Consul

- kind create cluster --config=kind/cluster.yaml
- helm install --values helm/consul-v1.yaml consul hashicorp/consul --create-namespace --namespace consul --version "0.48.0"
- kubectl port-forward svc/consul-ui --namespace consul 6443:443
- [Consul UI](https://localhost:6443/ui/)

## 02 - Install HashiCups

- kubectl apply --filename hashicups/v1/
- kubectl apply --filename hashicups/intentions/allow.yaml
- kubectl port-forward svc/nginx --namespace default 8080:80
- [HashiCups UI](http://localhost:8080/)

## 03 - Ingress with Consul on Kubernetes

- kubectl apply --kustomize "github.com/hashicorp/consul-api-gateway/config/crd?ref=v0.4.0"
- helm upgrade --values helm/consul-v2.yaml consul hashicorp/consul --namespace consul --version "0.48.0"
- kubectl apply --filename api-gw/consul-api-gateway.yaml --namespace consul && \
 kubectl wait --for=condition=ready gateway/api-gateway --namespace consul --timeout=90s && \
 kubectl apply --filename api-gw/routes.yaml --namespace consul
- kubectl apply --filename hashicups/v2/
- kubectl port-forward svc/consul-ui --namespace consul 6443:443
- [Consul UI](https://localhost:6443/ui/)
- [HashiCups UI](https://localhost:8443/)
- kubectl apply --filename hashicups/intentions/deny.yaml
- kubectl apply --filename hashicups/intentions/allow.yaml

## 04 - Observability with Consul on Kubernetes

- **Add Helm Repositories**
```sh
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
```
- **Install Observability Suite**
```sh
chmod 755 install-observability-suite.sh && \
./install-observability-suite.sh
```
- helm upgrade --values helm/consul-v3.yaml consul hashicorp/consul --namespace consul --version "0.46.1"
- kubectl apply -f proxy/proxy-defaults-grpc.yaml
- kubectl apply -f hashicups/v3/

- kubectl port-forward svc/consul-ui --namespace consul 6443:443
- [Consul UI](https://localhost:6443/ui/)
- kubectl port-forward svc/grafana --namespace default 3000:3000
- [Grafana UI](http://localhost:3000/)
- ***Login with admin/admin***
- kubectl port-forward svc/simplest-query --namespace default 9999:16686
- [Jaeger UI](http://localhost:9999/)
- kubectl port-forward svc/prometheus-server --namespace default 8888:80
- [Prometheus UI](http://localhost:8888/)
- kubectl port-forward svc/nginx --namespace default 8080:80
- [HashiCups UI](http://localhost:8080/)