#turning on all services

ecs-cli compose --project-name elastic --file docker-compose.elastic.yml --ecs-params ecs-param.elastic.yml service up --launch-type EC2 --create-log-groups  --cluster LEANDA --private-dns-namespace leanda  --vpc vpc-0f7d689f1b8d3615b --enable-service-discovery  --aws-profile arqisoft ;
ecs-cli compose --project-name mongo --file docker-compose.mongo.yml --ecs-params ecs-param.1.yml service up --launch-type EC2 --create-log-groups  --cluster LEANDA --private-dns-namespace leanda  --vpc vpc-0f7d689f1b8d3615b --enable-service-discovery  --aws-profile arqisoft ;
ecs-cli compose --project-name blob-storage-webapi --file docker-compose.blob-storage-webapi.yml --ecs-params ecs-param.1.yml service up --launch-type EC2 --create-log-groups  --cluster LEANDA --private-dns-namespace leanda  --vpc vpc-0f7d689f1b8d3615b --enable-service-discovery  --aws-profile arqisoft ;
ecs-cli compose --project-name rabbitmq --file docker-compose.rabbit.yml --ecs-params ecs-param.1.yml service up --launch-type EC2 --create-log-groups  --cluster LEANDA --private-dns-namespace leanda  --vpc vpc-0f7d689f1b8d3615b --enable-service-discovery  --aws-profile arqisoft ;
ecs-cli compose --project-name redis --file docker-compose.redis.yml --ecs-params ecs-param.1.yml service up --launch-type EC2 --create-log-groups  --cluster LEANDA --private-dns-namespace leanda  --vpc vpc-0f7d689f1b8d3615b --enable-service-discovery  --aws-profile arqisoft ;
ecs-cli compose --project-name eventstore --file docker-compose.eventstore.yml --ecs-params ecs-param.1.yml service up --launch-type EC2 --create-log-groups  --cluster LEANDA --private-dns-namespace leanda  --vpc vpc-0f7d689f1b8d3615b --enable-service-discovery  --aws-profile arqisoft ;


ecs-cli compose --project-name core-persistence --file docker-compose.core-persistence.yml --ecs-params ecs-param.core.yml service up --launch-type FARGATE --create-log-groups  --cluster LEANDA --private-dns-namespace leanda  --vpc vpc-0f7d689f1b8d3615b --enable-service-discovery  --aws-profile arqisoft;
ecs-cli compose --project-name sagahost --file docker-compose.sagahost.yml --ecs-params ecs-param.core.yml service up --launch-type FARGATE --create-log-groups  --cluster LEANDA --private-dns-namespace leanda  --vpc vpc-0f7d689f1b8d3615b --enable-service-discovery  --aws-profile arqisoft;
ecs-cli compose --project-name core-backend --file docker-compose.core-backend.yml --ecs-params ecs-param.core.yml service up --launch-type FARGATE --create-log-groups  --cluster LEANDA --private-dns-namespace leanda  --vpc vpc-0f7d689f1b8d3615b --enable-service-discovery  --aws-profile arqisoft;
ecs-cli compose --project-name core-frontend --file docker-compose.core-frontend.yml --ecs-params ecs-param.core.yml service up --launch-type FARGATE --create-log-groups  --cluster LEANDA --private-dns-namespace leanda  --vpc vpc-0f7d689f1b8d3615b --enable-service-discovery  --aws-profile arqisoft;
ecs-cli compose --project-name webapi --file docker-compose.webapi.yml --ecs-params ecs-param.core.yml service up --launch-type FARGATE --create-log-groups  --cluster LEANDA --private-dns-namespace leanda  --vpc vpc-0f7d689f1b8d3615b --enable-service-discovery  --aws-profile arqisoft;
ecs-cli compose --project-name indexing --file docker-compose.indexing.yml --ecs-params ecs-param.core.yml service up --launch-type FARGATE --create-log-groups  --cluster LEANDA --private-dns-namespace leanda  --vpc vpc-0f7d689f1b8d3615b --enable-service-discovery  --aws-profile arqisoft;
ecs-cli compose --project-name imaging --file docker-compose.imaging.yml --ecs-params ecs-param.core.yml service up --launch-type FARGATE --create-log-groups  --cluster LEANDA --private-dns-namespace leanda  --vpc vpc-0f7d689f1b8d3615b --enable-service-discovery  --aws-profile arqisoft;

ecs-cli compose --project-name office-processor --file docker-compose.office-processor.yml --ecs-params ecs-param.core.yml service up --launch-type FARGATE --create-log-groups  --cluster LEANDA --private-dns-namespace leanda  --vpc vpc-0f7d689f1b8d3615b --enable-service-discovery  --aws-profile arqisoft;
ecs-cli compose --project-name nginx --file docker-compose.nginx.yml --ecs-params ecs-param.core.yml service up --launch-type FARGATE --create-log-groups  --cluster LEANDA --private-dns-namespace leanda  --vpc vpc-0f7d689f1b8d3615b --enable-service-discovery  --aws-profile arqisoft;
ecs-cli compose --project-name metadata-processing --file docker-compose.metadata-processing.yml --ecs-params ecs-param.core.yml service up --launch-type FARGATE --create-log-groups  --cluster LEANDA --private-dns-namespace leanda  --vpc vpc-0f7d689f1b8d3615b --enable-service-discovery  --aws-profile arqisoft;
ecs-cli compose --project-name chemical-file-parser --file docker-compose.chemical-file-parser.yml --ecs-params ecs-param.core.yml service up --launch-type FARGATE --create-log-groups  --cluster LEANDA --private-dns-namespace leanda  --vpc vpc-0f7d689f1b8d3615b --enable-service-discovery  --aws-profile arqisoft;
ecs-cli compose --project-name reaction-parser --file docker-compose.reaction-parser.yml --ecs-params ecs-param.core.yml service up --launch-type FARGATE --create-log-groups  --cluster LEANDA --private-dns-namespace leanda  --vpc vpc-0f7d689f1b8d3615b --enable-service-discovery  --aws-profile arqisoft;
ecs-cli compose --project-name crystal-parser --file docker-compose.crystal-parser.yml --ecs-params ecs-param.core.yml service up --launch-type FARGATE --create-log-groups  --cluster LEANDA --private-dns-namespace leanda  --vpc vpc-0f7d689f1b8d3615b --enable-service-discovery  --aws-profile arqisoft;
ecs-cli compose --project-name spectra-parser --file docker-compose.spectra-parser.yml --ecs-params ecs-param.core.yml service up --launch-type FARGATE --create-log-groups  --cluster LEANDA --private-dns-namespace leanda  --vpc vpc-0f7d689f1b8d3615b --enable-service-discovery  --aws-profile arqisoft;
ecs-cli compose --project-name chemical-properties --file docker-compose.chemical-properties.yml --ecs-params ecs-param.core.yml service up --launch-type FARGATE --create-log-groups  --cluster LEANDA --private-dns-namespace leanda  --vpc vpc-0f7d689f1b8d3615b --enable-service-discovery  --aws-profile arqisoft;
ecs-cli compose --project-name chemical-export --file docker-compose.chemical-export.yml --ecs-params ecs-param.core.yml service up --launch-type FARGATE --create-log-groups  --cluster LEANDA --private-dns-namespace leanda  --vpc vpc-0f7d689f1b8d3615b --enable-service-discovery  --aws-profile arqisoft;

ecs-cli compose --project-name web-importer --file docker-compose.web-importer.yml --ecs-params ecs-param.core.yml service up --launch-type FARGATE --create-log-groups  --cluster LEANDA --private-dns-namespace leanda  --vpc vpc-0f7d689f1b8d3615b --enable-service-discovery  --aws-profile arqisoft;
ecs-cli compose --project-name microscopy-metadata --file docker-compose.microscopy-metadata.yml --ecs-params ecs-param.core.yml service up --launch-type FARGATE --create-log-groups  --cluster LEANDA --private-dns-namespace leanda  --vpc vpc-0f7d689f1b8d3615b --enable-service-discovery  --aws-profile arqisoft;
ecs-cli compose --project-name categories --file docker-compose.categories.yml --ecs-params ecs-param.core.yml service up --launch-type FARGATE --create-log-groups  --cluster LEANDA --private-dns-namespace leanda  --vpc vpc-0f7d689f1b8d3615b --enable-service-discovery  --aws-profile arqisoft;


#turning off all services

ecs-cli compose --project-name eventstore --file docker-compose.eventstore.yml --ecs-params ecs-param.1.yml service down --cluster LEANDA --delete-namespace --aws-profile arqisoft;
ecs-cli compose --project-name blob-storage-webapi --file docker-compose.blob-storage-webapi.yml --ecs-params ecs-param.1.yml service down  --cluster LEANDA   --aws-profile arqisoft;
ecs-cli compose --project-name elastic --file docker-compose.elastic.yml --ecs-params ecs-param.1.yml service down  --cluster LEANDA  --aws-profile arqisoft;
ecs-cli compose --project-name mongo --file docker-compose.mongo.yml --ecs-params ecs-param.1.yml service down --cluster LEANDA --aws-profile arqisoft;
ecs-cli compose --project-name redis --file docker-compose.redis.yml --ecs-params ecs-param.1.yml service down --cluster LEANDA   --aws-profile arqisoft;
ecs-cli compose --project-name rabbitmq --file docker-compose.rabbit.yml --ecs-params ecs-param.1.yml service down  --cluster LEANDA  --aws-profile arqisoft;

ecs-cli compose --project-name core-persistence --file docker-compose.core-persistence..yml --ecs-params ecs-param.core.yml service down --cluster LEANDA  --aws-profile arqisoft;
ecs-cli compose --project-name sagahost --file docker-compose.sagahost.yml --ecs-params ecs-param.core.yml service down --cluster LEANDA  --aws-profile arqisoft;
ecs-cli compose --project-name core-backend --file docker-compose.core-backend.yml --ecs-params ecs-param.core.yml service down --cluster LEANDA  --aws-profile arqisoft;
ecs-cli compose --project-name core-frontend --file docker-compose.core-frontend.yml --ecs-params ecs-param.core.yml service down --cluster LEANDA  --aws-profile arqisoft;
ecs-cli compose --project-name webapi --file docker-compose.webapi.yml --ecs-params ecs-param.core.yml service down --cluster LEANDA  --aws-profile arqisoft;
ecs-cli compose --project-name indexing --file docker-compose.indexing.yml --ecs-params ecs-param.core.yml service down --cluster LEANDA  --aws-profile arqisoft;

ecs-cli compose --project-name imaging --file docker-compose.imaging.yml --ecs-params ecs-param.core.yml service down --cluster LEANDA  --aws-profile arqisoft;

ecs-cli compose --project-name office-processor --file docker-compose.office-processor.yml --ecs-params ecs-param.core.yml service down --cluster LEANDA  --aws-profile arqisoft;
ecs-cli compose --project-name nginx --file docker-compose.nginx.yml --ecs-params ecs-param.core.yml service down --cluster LEANDA  --aws-profile arqisoft;
ecs-cli compose --project-name metadata-processing --file docker-compose.metadata-processing.yml --ecs-params ecs-param.core.yml service down --cluster LEANDA  --aws-profile arqisoft;
ecs-cli compose --project-name chemical-file-parser --file docker-compose.chemical-file-parser.yml --ecs-params ecs-param.core.yml service down --cluster LEANDA  --aws-profile arqisoft;
ecs-cli compose --project-name reaction-parser --file docker-compose.reaction-parser.yml --ecs-params ecs-param.core.yml service down --cluster LEANDA  --aws-profile arqisoft;
ecs-cli compose --project-name crystal-parser --file docker-compose.crystal-parser.yml --ecs-params ecs-param.core.yml service down --cluster LEANDA  --aws-profile arqisoft;
ecs-cli compose --project-name spectra-parser --file docker-compose.spectra-parser.yml --ecs-params ecs-param.core.yml service down --cluster LEANDA  --aws-profile arqisoft;
ecs-cli compose --project-name chemical-properties --file docker-compose.chemical-properties.yml --ecs-params ecs-param.core.yml service down --cluster LEANDA  --aws-profile arqisoft;
ecs-cli compose --project-name chemical-export --file docker-compose.chemical-export.yml --ecs-params ecs-param.core.yml service down --cluster LEANDA  --aws-profile arqisoft;
ecs-cli compose --project-name web-importer --file docker-compose.web-importer.yml --ecs-params ecs-param.core.yml service down --cluster LEANDA  --aws-profile arqisoft;
ecs-cli compose --project-name microscopy-metadata --file docker-compose.microscopy-metadata.yml --ecs-params ecs-param.core.yml service down --cluster LEANDA  --aws-profile arqisoft;
ecs-cli compose --project-name categories --file docker-compose.categories.yml --ecs-params ecs-param.core.yml service down --cluster LEANDA  --aws-profile arqisoft;