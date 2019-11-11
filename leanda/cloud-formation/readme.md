# Leanda AWS CloudFormation

## Create a new cluster

Create a new stack by uploading `ec2-spotInsance-ECS-Cluster.yml`. Specify the cluster name (LEANDA is the default, for example).

## Start all services

Replace cluster name if needed.

```terminal
ecs-cli compose up --region us-east-1 --cluster LEANDA --aws-profile default
```
