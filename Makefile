include Makefile.properties
BASEDIR = $(shell pwd)

get-cluster:
	gcloud container clusters get-credentials  ${CLUSTER} --project ${PROJECT} --zone ${ZONE}


create.grafana:
	 kubectl apply -f ${BASEDIR}/grafana/grafana-configmap.yaml
	 kubectl apply -f ${BASEDIR}/grafana/grafana.yaml

get.grafana:
	kubectl get pod | grep grafana
	kubectl get svc | grep grafana
	kubectl get configmap | grep grafana

restart.grafana:
	kubectl rollout restart sts grafana

destroy.grafana:
	 kubectl delete -f ${BASEDIR}/grafana/grafana-configmap.yaml
	 kubectl delete -f ${BASEDIR}/grafana/grafana.yaml


create.prometheus:
	kubectl apply -f ${BASEDIR}/prometheus/prometheus-configmap.yaml
	kubectl apply -f ${BASEDIR}/prometheus/stateful-prometheus.yaml
	kubectl apply -f ${BASEDIR}/prometheus/external-lb-stateful-prometheus.yaml

get.prometheus:
	kubectl get pod | grep prometheus
	kubectl get svc | grep prometheus
	kubectl get configmap | grep prometheus

restart.prometheus:
	kubectl rollout restart sts prometheus-server

rollout.prometheus:
	kubectl delete -f ${BASEDIR}/prometheus/prometheus-configmap.yaml 
	kubectl apply -f ${BASEDIR}/prometheus/prometheus-configmap.yaml
	kubectl rollout restart sts prometheus-server



destroy.prometheus:
	kubectl delete -f ${BASEDIR}/prometheus/prometheus-configmap.yaml
	kubectl delete -f ${BASEDIR}/prometheus/stateful-prometheus.yaml
	kubectl delete -f ${BASEDIR}/prometheus/external-lb-stateful-prometheus.yaml


destroy.all: destroy.prometheus destroy.grafana

create.all: create.prometheus create.grafana