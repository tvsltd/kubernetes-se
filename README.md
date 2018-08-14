# Kubernetes

The entire SE deployment is subdivided into a set of K8s Namespaces, based on separation 
of functions. The main operational namespace is `smartemission`.

## Ingress-Nginx

Proxy server

```
$ kubectl apply -f ./ingress-nginx/namespace.yml
$ kubectl apply -f ./ingress-nginx/default-backend.yml
$ kubectl apply -f ./ingress-nginx/config-map.yml
$ kubectl apply -f ./ingress-nginx/tcp-services-configmap.yml
$ kubectl apply -f ./ingress-nginx/udp-services-configmap.yml
$ kubectl apply -f ./ingress-nginx/without-rbac.yml
$ kubectl patch deployment -n ingress-nginx nginx-ingress-controller --type='json' --patch=$(cat ./ingress-nginx/publish-service-patch.yml)
$ kubectl apply -f ./ingress-nginx/service.yml
$ kubectl apply -f ./ingress-nginx/patch-service-without-rbac.yml
```

## Cert-Manager

`Let's encrypt` cert manager. Set your email address in 
the files `letsencrypt-staging.clusterissuer.yml` and `letsencrypt-prod.clusterissuer.yml`.

```
$ kubectl create -f ./cert-manager/namespace.yml
$ kubectl create -f ./cert-manager/crd.yml
$ kubectl create -f ./cert-manager/deployment.yml
$ kubectl create -f ./cert-manager/letsencrypt-staging.clusterissuer.yml
$ kubectl create -f ./cert-manager/letsencrypt-prod.clusterissuer.yml
```

## Smart Emission

The main Smart Emission stack.

### Namespace

```
$ kubectl create -f ./smartemission/namespace.yml
```

### Certificate

```
$ kubectl create -f ./smartemission/certificate.yml
```

### Secrets

Secrets not included in the repository.

```
$ kubectl create -f ./smartemission/secrets/geoserver.yml
$ kubectl create -f ./smartemission/secrets/postgres.yml
$ kubectl create -f ./smartemission/secrets/basic-auth.yml
$ kubectl create -f ./smartemission/secrets/sos52n.yml
$ kubectl create -f ./smartemission/secrets/data-collectors.yml
```

### Services / Deployments

The `postgres-external.yml` service is not available in the repository. 
Create your own with the name `postgres`.

```
$ kubectl create -f ./smartemission/services/postgres-external/deployment.yml
$ kubectl create -f ./smartemission/services/postgres-external/service.yml

$ kubectl create -f ./smartemission/services/geoserver/deployment.yml
$ kubectl create -f ./smartemission/services/geoserver/service.yml
$ kubectl create -f ./smartemission/services/geoserver/ingress.yml

$ kubectl create -f ./smartemission/services/basic-auth-geoserver/deployment.yml
$ kubectl create -f ./smartemission/services/basic-auth-geoserver/service.yml
$ kubectl create -f ./smartemission/services/basic-auth-geoserver/ingress.yml

$ kubectl create -f ./smartemission/services/sos52n/deployment.yml
$ kubectl create -f ./smartemission/services/sos52n/service.yml
$ kubectl create -f ./smartemission/services/sos52n/ingress.yml

$ kubectl create -f ./smartemission/services/sosemu/deployment.yml
$ kubectl create -f ./smartemission/services/sosemu/service.yml
$ kubectl create -f ./smartemission/services/sosemu/ingress.yml

$ kubectl create -f ./smartemission/services/influxdb/service.yml
$ kubectl create -f ./smartemission/services/influxdb/statefulset.yml

$ kubectl create -f ./smartemission/services/smartapp/deployment.yml
$ kubectl create -f ./smartemission/services/smartapp/service.yml
$ kubectl create -f ./smartemission/services/smartapp/ingress.yml

$ kubectl create -f ./smartemission/services/waalkade/deployment.yml
$ kubectl create -f ./smartemission/services/waalkade/service.yml
$ kubectl create -f ./smartemission/services/waalkade/ingress.yml

$ kubectl create -f ./smartemission/services/home/deployment.yml
$ kubectl create -f ./smartemission/services/home/service.yml
$ kubectl create -f ./smartemission/services/home/ingress.yml

$ kubectl create -f ./smartemission/services/heron/deployment.yml
$ kubectl create -f ./smartemission/services/heron/service.yml
$ kubectl create -f ./smartemission/services/heron/ingress.yml

$ kubectl create -f ./smartemission/services/mosquitto/deployment.yml
$ kubectl create -f ./smartemission/services/mosquitto/service.yml

$ kubectl create -f ./smartemission/services/gost/deployment.yml
$ kubectl create -f ./smartemission/services/gost/service.yml
$ kubectl create -f ./smartemission/services/gost/ingress.yml

$ kubectl create -f ./smartemission/services/admin/deployment.yml
$ kubectl create -f ./smartemission/services/admin/service.yml
$ kubectl create -f ./smartemission/services/admin/ingress.yml

$ kubectl create -f ./smartemission/services/postgres-pool/deployment.yml
$ kubectl create -f ./smartemission/services/postgres-pool/service.yml
```

### CronJobs

Harvesters:

```
$ kubectl create -f ./smartemission/cronjobs/etl-last.yml
$ kubectl create -f ./smartemission/cronjobs/etl-whale.yml
$ kubectl create -f ./smartemission/cronjobs/etl-rivm-harvester.yml
$ kubectl create -f ./smartemission/cronjobs/etl-influxdb-harvester.yml
$ kubectl create -f ./smartemission/cronjobs/etl-extractor.yml
```

Refiners:

```
$ kubectl create -f ./smartemission/cronjobs/etl-refiner.yml
```

Publishers:

```
$ kubectl create -f ./smartemission/cronjobs/etl-sta-publisher.yml
$ kubectl create -f ./smartemission/cronjobs/etl-sos-publisher.yml
```

## Collectors

Smart Emission-owned Data Collectors (other DCs are owned by 3rd parties like Intemo and CityGIS). 
Could also be run outside the cluster.

### Namespace

```
$ kubectl create -f ./collectors/namespace.yml
```

### Secrets

Secrets not included in the repository. ??


### Services / Deployments

Mainly an InfluxDB Data Collector for the AirSensEUR project, plus a 
Grafana Dashboard to view/inspect collected data.

```
$ kubectl create -f ./collectors/services/dc-airsenseur/service.yml
$ kubectl create -f ./collectors/services/dc-airsenseur/statefulset.yml

$ kubectl create -f ./collectors/services/dc-grafana/deployment.yml
$ kubectl create -f ./collectors/services/dc-grafana/service.yml
$ kubectl create -f ./collectors/services/dc-grafana/ingress.yml

```


## Monitoring

### Namespace

```
$ kubectl create -f ./monitoring/namespace.yml
```

### Secrets

Secrets not included in the repository.

```
$ kubectl create -f ./monitoring/secrets/basic-auth.yml
$ kubectl create -f ./monitoring/secrets/phppgadmin.yml
```

### Services / Deployments

```
$ kubectl create -f ./monitoring/services/elasticsearch/service.yml
$ kubectl create -f ./monitoring/services/elasticsearch/stateful-set.yml

$ kubectl create -f ./monitoring/services/fluentd/config-map.yml
$ kubectl create -f ./monitoring/services/fluentd/daemon-set.yml

$ kubectl create -f ./monitoring/services/kibana/deployment.yml
$ kubectl create -f ./monitoring/services/kibana/service.yml
$ kubectl create -f ./monitoring/services/kibana/ingress.yml

$ kubectl create -f ./monitoring/services/phppgadmin/pvc.yml
$ kubectl create -f ./monitoring/services/phppgadmin/deployment.yml
$ kubectl create -f ./monitoring/services/phppgadmin/service.yml
$ kubectl create -f ./monitoring/services/phppgadmin/ingress.yml
```

## Kube-System

### Secrets

Secrets not included in the repository.

```
$ kubectl create -f ./kube-system/secrets/basic-auth.yml
```

### Services / Deployments

```
$ kubectl create -f ./kube-system/services/kubernetes-dashboard/ingress.yml
```