#turning on all services

ecs-cli compose --project-name elastic --file docker-compose.elastic.yml --ecs-params ecs-param.elastic.yml service up --launch-type EC2 --create-log-groups  --cluster LEANDA --private-dns-namespace leanda  --vpc vpc-00e43aefcd381a2fc --enable-service-discovery  --aws-profile arqisoft
ecs-cli compose --project-name mongo --file docker-compose.mongo.yml --ecs-params ecs-param.1.yml service up --launch-type EC2 --create-log-groups  --cluster LEANDA --private-dns-namespace leanda  --vpc vpc-00e43aefcd381a2fc --enable-service-discovery  --aws-profile arqisoft
ecs-cli compose --project-name blob --file docker-compose.blob.yml --ecs-params ecs-param.1.yml service up --launch-type EC2 --create-log-groups  --cluster LEANDA --private-dns-namespace leanda  --vpc vpc-00e43aefcd381a2fc --enable-service-discovery  --aws-profile arqisoft
ecs-cli compose --project-name rabbitmq --file docker-compose.rabbit.yml --ecs-params ecs-param.1.yml service up --launch-type EC2 --create-log-groups  --cluster LEANDA --private-dns-namespace leanda  --vpc vpc-00e43aefcd381a2fc --enable-service-discovery  --aws-profile arqisoft
ecs-cli compose --project-name redis --file docker-compose.redis.yml --ecs-params ecs-param.1.yml service up --launch-type EC2 --create-log-groups  --cluster LEANDA --private-dns-namespace leanda  --vpc vpc-00e43aefcd381a2fc --enable-service-discovery  --aws-profile arqisoft
ecs-cli compose --project-name eventstore --file docker-compose.eventstore.yml --ecs-params ecs-param.1.yml service up --launch-type EC2 --create-log-groups  --cluster LEANDA --private-dns-namespace leanda  --vpc vpc-00e43aefcd381a2fc --enable-service-discovery  --aws-profile arqisoft


ecs-cli compose --project-name core-persistence --file docker-compose.core-persistence.yml --ecs-params ecs-param.core.yml service up --launch-type FARGATE --create-log-groups  --cluster LEANDA --private-dns-namespace leanda  --vpc vpc-00e43aefcd381a2fc --enable-service-discovery  --aws-profile arqisoft
ecs-cli compose --project-name sagahost --file docker-compose.sagahost.yml --ecs-params ecs-param.core.yml service up --launch-type FARGATE --create-log-groups  --cluster LEANDA --private-dns-namespace leanda  --vpc vpc-00e43aefcd381a2fc --enable-service-discovery  --aws-profile arqisoft
ecs-cli compose --project-name core-backend --file docker-compose.core-backend.yml --ecs-params ecs-param.core.yml service up --launch-type FARGATE --create-log-groups  --cluster LEANDA --private-dns-namespace leanda  --vpc vpc-00e43aefcd381a2fc --enable-service-discovery  --aws-profile arqisoft
ecs-cli compose --project-name core-frontend --file docker-compose.core-frontend.yml --ecs-params ecs-param.core.yml service up --launch-type FARGATE --create-log-groups  --cluster LEANDA --private-dns-namespace leanda  --vpc vpc-00e43aefcd381a2fc --enable-service-discovery  --aws-profile arqisoft
ecs-cli compose --project-name webapi --file docker-compose.webapi.yml --ecs-params ecs-param.core.yml service up --launch-type FARGATE --create-log-groups  --cluster LEANDA --private-dns-namespace leanda  --vpc vpc-00e43aefcd381a2fc --enable-service-discovery  --aws-profile arqisoft
ecs-cli compose --project-name indexing --file docker-compose.indexing.yml --ecs-params ecs-param.core.yml service up --launch-type FARGATE --create-log-groups  --cluster LEANDA --private-dns-namespace leanda  --vpc vpc-00e43aefcd381a2fc --enable-service-discovery  --aws-profile arqisoft
ecs-cli compose --project-name imaging --file docker-compose.imaging.yml --ecs-params ecs-param.core.yml service up --launch-type FARGATE --create-log-groups  --cluster LEANDA --private-dns-namespace leanda  --vpc vpc-00e43aefcd381a2fc --enable-service-discovery  --aws-profile arqisoft



#turning off all services

ecs-cli compose --project-name eventstore --file docker-compose.eventstore.yml --ecs-params ecs-param.1.yml service down --cluster LEANDA  --aws-profile arqisoft
ecs-cli compose --project-name blob --file docker-compose.blob.yml --ecs-params ecs-param.1.yml service down  --cluster LEANDA   --aws-profile arqisoft
ecs-cli compose --project-name elastic --file docker-compose.elastic.yml --ecs-params ecs-param.1.yml service down  --cluster LEANDA  --aws-profile arqisoft
ecs-cli compose --project-name mongo --file docker-compose.mongo.yml --ecs-params ecs-param.1.yml service down --cluster LEANDA --aws-profile arqisoft
ecs-cli compose --project-name redis --file docker-compose.redis.yml --ecs-params ecs-param.1.yml service down --cluster LEANDA   --aws-profile arqisoft
ecs-cli compose --project-name rabbitmq --file docker-compose.rabbit.yml --ecs-params ecs-param.1.yml service down  --cluster LEANDA  --aws-profile arqisoft

ecs-cli compose --project-name core-persistence --file docker-compose.core.yml --ecs-params ecs-param.core.yml service down --cluster LEANDA  --aws-profile arqisoft
ecs-cli compose --project-name sagahost --file docker-compose.sagahost.yml --ecs-params ecs-param.core.yml service down --cluster LEANDA  --aws-profile arqisoft
ecs-cli compose --project-name core-backend --file docker-compose.core-backend.yml --ecs-params ecs-param.core.yml service down --cluster LEANDA  --aws-profile arqisoft
ecs-cli compose --project-name core-frontend --file docker-compose.core-frontend.yml --ecs-params ecs-param.core.yml service down --cluster LEANDA  --aws-profile arqisoft
ecs-cli compose --project-name webapi --file docker-compose.webapi.yml --ecs-params ecs-param.core.yml service down --cluster LEANDA  --aws-profile arqisoft
ecs-cli compose --project-name indexing --file docker-compose.indexing.yml --ecs-params ecs-param.core.yml service down --cluster LEANDA  --aws-profile arqisoft

ecs-cli compose --project-name imaging --file docker-compose.imaging.yml --ecs-params ecs-param.core.yml service down --cluster LEANDA  --aws-profile arqisoft

