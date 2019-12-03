# Leanda AWS CloudFormation

## Create a new cluster

Create a new stack by uploading `ec2-spotInsance-ECS-Cluster.yml`. Specify the cluster name (LEANDA is the default, for example).

## Start all services

Replace cluster name if needed. It needs to use a valid cluster (as created with the above CF template)

```terminal
ecs-cli compose up --cluster LEANDA --cluster-config leanda --force-update --launch-type EC2 --create-log-groups --aws-profile default
```

## docker-compose files

`docker-compose.1.yml`

```terminal
elasticsearch
eventstore
mongo
nginx
rabbitmq
redis
```

`docker-compose.2.yml`

```terminal
blob-storage-api
core-persistence
core-sagahost
core-backend
core-frontend
core-web-api
indexing
```

`docker-compose.3.yml`

```terminal
categories
chemical-export
chemical-file-parser
chemical-properties
crystal-file-parser
imaging
metadata-processing
microscopy-metadata
office-processor
reaction-file-parser
spectra-file-parser
web-importer
```
