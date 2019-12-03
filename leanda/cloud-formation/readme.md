# Leanda AWS CloudFormation

## Create a new cluster for back-end services

Create a new stack by uploading `cf-backend.yml`.

Specify the following:

* Cluster name (LEANDA is the default, for example).
* Snapshot ID (look it up under EC/Snapshots in AWS Console).
* Price for the EC2 Spot Instance

## Create infrastructure for front-end services

Create a new stack by uploading `cf-frontend.yml`.

Specify the following:

* The ARN of the certificate to be used with this distribution (lookup under Certificate Manager in AWS Console)
* The root domain name (default leanda.io)
* The full domain name e.g. labwiz.leanda.io
* PriceClass The CloudFront distribution price class

## Start all services

Replace cluster name if needed. It needs to use a valid cluster (as created with the above CF template)

```terminal
ecs-cli compose up --cluster LEANDA --cluster-config leanda --force-update --launch-type EC2 --create-log-groups --aws-profile default
```

### docker-compose files

ECS has a restriction of 10 containers per task definion.

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
