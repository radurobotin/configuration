# Leanda Configuration

## Run everything on one machine

```terminal
docker-compose up
```

## Run in AWS with CloudWatch logs

```terminal
docker-compose -f docker-compose.backend.yml -f docker-compose.aws.yml up
```

For more info see docs: [Amazon CloudWatch Logs logging driver](https://docs.docker.com/config/containers/logging/awslogs/)
