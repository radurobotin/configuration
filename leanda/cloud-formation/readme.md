# Leanda AWS CloudFormation

## Prerequisites

- aws-cli
- ecs-cli
- jq

## Create a new cluster for back-end services

Create a new stack by uploading `cf-backend.yml`.

Specify the following:

- Cluster name (LEANDA is the default, for example).
- Snapshot ID (look it up under EC/Snapshots in AWS Console).
- Price for the EC2 Spot Instance

## Create infrastructure for front-end services

Create a new stack by uploading `cf-frontend.yml`.

Specify the following:

- The ARN of the certificate to be used with this distribution (lookup under Certificate Manager in AWS Console)
- The root domain name (default leanda.io)
- The full domain name e.g. labwiz.leanda.io
- PriceClass The CloudFront distribution price class

## Start all services

Replace cluster name if needed. It needs to use a valid cluster (as created with the above CF template)

```terminal
ecs-cli compose --project-name leanda --file docker-compose.1.yml --ecs-params ecs-param.1.yml up --launch-type EC2 --aws-profile default --create-log-groups --cluster-config leanda --cluster LEANDA --force-update

ecs-cli compose --project-name leanda --file docker-compose.2.yml --ecs-params ecs-param.2.yml up --launch-type EC2 --aws-profile default --create-log-groups --cluster-config leanda --cluster LEANDA --force-update

ecs-cli compose --project-name leanda --file docker-compose.3.yml --ecs-params ecs-param.3.yml up --launch-type EC2 --aws-profile default --create-log-groups --cluster-config leanda --cluster LEANDA --force-update

ecs-cli compose --project-name leanda --file docker-compose.4.yml --ecs-params ecs-param.4.yml up --launch-type EC2 --aws-profile default --create-log-groups --cluster-config leanda --cluster LEANDA --force-update
```

### docker-compose files

ECS has a restriction of 10 containers per task definion.

`docker-compose.1.yml`

```terminal
elasticsearch
eventstore
mongo
rabbitmq
redis
blob-storage-web-api
```

`docker-compose.2.yml`

```terminal
nginx
core-persistence
core-sagahost
core-backend
core-frontend
core-web-api
indexing
imaging
office-processor
```

`docker-compose.3.yml`

```terminal
chemical-export
chemical-file-parser
chemical-properties
crystal-file-parser
metadata-processing
reaction-file-parser
spectra-file-parser
web-importer
```

`docker-compose.4.yml`

```terminal
categories
microscopy-metadata
```

## Limiting resources

The number of CPU units used by the task. It can be expressed as an integer using CPU units, for example 1024, or as a string using vCPUs, for example '1 vCPU' or '1 vcpu'.
