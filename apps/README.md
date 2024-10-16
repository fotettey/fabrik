## AlertManager:
AlertManager TLS: https://prometheus.io/docs/alerting/latest/https/
### Configs: https://prometheus.io/docs/prometheus/latest/getting_started/
## Alerting RUle example for SMTP: https://github.com/prometheus/alertmanager/blob/main/doc/examples/simple.yml

https://crashlaker.github.io/2022/06/14/docker_compose_prometheus_alertmanager_grafana.html

https://github.com/PagerTree/prometheus-grafana-alertmanager-example/blob/master/docker-compose.yml

## Prometheus:
https://istio.io/latest/docs/ops/integrations/prometheus/
https://istio.io/latest/docs/ops/integrations/prometheus/#tls-settings
https://istio.io/latest/docs/ops/best-practices/observability/#using-prometheus-for-production-scale-monitoring
https://karlstoney.com/federated-prometheus-to-reduce-metric-cardinality/
https://github.com/istio/istio/blob/ac2ce6424c75446107f717f95ea537470c39b16c/manifests/istio-telemetry/prometheus/templates/configmap.yaml?ref=karlstoney.com#L29
https://gist.github.com/Stono/9ad07fca8c447c3ee3ac2c8a546d8acf?ref=karlstoney.com




# OTEL:
Specification, API, SDK, data model - OTLP, Auto-Instrumentation, Collector
- Helm Chart, Kubernetes Operator
## OTEL is only data colleciton.
- It is not platform, storage nor query API
## OpenTelemetry Instrumentation (How Telemetry data is created)
- Explicit/Manual
- Direct Integration in Runtimes - eg. Quarkus, Wildfly, etc.
- Auto-Instrumentation / Agent

## OTEL COLLECTOR
### How telemetry data is collected & exporteed to a PLATFORM.
Written in GoLang
2 Main Distributions & BYO:
- Core
- Contrib
- Build Your Own
## Many components url/opentelemetry-collector-contrib
- Distributed as: binary, container image, APK/DEB/RPM
## 3 Key Collector Components:
- Receivers: Opens up a PORT to receive some data, or reads/uses a file from the filesystem.
- Processors: Data collected from the RECEIVERS are sent to PROCESSORs for BATCHING, Deduplicaiton, Data Drop, Custom Processing Params, Re-Labelling, etc.
- Exporters: Exporters send the prepared data to the defined targets

## OTEL Kubernetes Operator:
Manages OTEL Collector & Instrumentation
https://github.com/open-telemetry/opentelemetry-operator
K8s CRDs:
- opentelemetrycollectors.opentelemetry.io / otelcol
- instrumentation.opentelemetry.io / otelinst
## K8s Operator Installation:
Can be installed by OLM, Helm/ K8s manifests.
## Collector CRD:
1. ## OTEL Operator - Collector Kind
- Deployment Modes: .spec.mode
    - sidecar,deployment, daemonset, statefulset
- Auto scaling or kubectl scale --replicas=5 otelcols/simplest
- Expose outside of the Cluster .spec.ingress
- Use custom collector image .spec.image
2. ## OTEL Operator - Instrumentation:

## Implementation:
- 
- 
- 

helm upgrade --install -f values.yaml \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --version v1.16.1 \
  --set crds.enabled=true