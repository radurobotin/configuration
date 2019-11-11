# Leanda AWS CloudFormation

## Create a new cluster

Create a new stack by uploading `ec2-spotInsance-ECS-Cluster.yml`. Specify the cluster name (LEANDA is the default, for example).

## Start all services

Replace cluster name if needed. It needs to use a valid cluster (as created with the above CF template)

```terminal
ecs-cli compose up --cluster LEANDA --cluster-config leanda --force-update --launch-type EC2 --create-log-groups --aws-profile default
```


