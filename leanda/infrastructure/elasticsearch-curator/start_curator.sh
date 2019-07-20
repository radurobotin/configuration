cd $CONFIGURATION_PATH/osdr/infrastructure/elasticsearch-curator
docker build -t "docker.your-company.com/elasticsearch-curator:latest" .
cd $CONFIGURATION_PATH/osdr/docker
$DOCKER_COMPOSE_PATH/docker-compose -f docker-compose.infrastructure.${DEPLOY_ENVIRONMENT}.yml up elasticsearch-curator
