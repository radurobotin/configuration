#!/bin/bash
set -e

usage() { echo "Usage: $0  [-p <aws_profile>] where <aws_profile> is the name you have saved your AWS Credentials in ~/.aws/credentials. This command requires that you have installed aws-cli, ecs-cli and jq. " 1>&2; exit 1; }

while getopts ":p:" o; do
    case "${o}" in
        p)
            p=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done

shift $((OPTIND-1))

if  [ -z "${p}" ]; then
    usage
fi

exit_on_error() {
    exit_code=$1
    last_command=${@:2}
    if [ $1 -ne 0 ]; then
        >&2 echo "\"${last_command}\" command failed with exit code ${exit_code}."
        exit $exit_code
    fi
}

echo "AWS-CLI profile selected:  ${p}"

echo "Removing running containers from the stack..."


ecs-cli compose --project-name nginx --file docker-compose.nginx.yml  service down --cluster LEANDA  --aws-profile=${p};
ecs-cli compose --project-name categories --file docker-compose.categories.yml  service down --cluster LEANDA  --aws-profile=${p};
ecs-cli compose --project-name office-processor --file docker-compose.office-processor.yml  service down --cluster LEANDA  --aws-profile=${p};
ecs-cli compose --project-name microscopy-metadata --file docker-compose.microscopy-metadata.yml service down --cluster LEANDA  --aws-profile=${p};
ecs-cli compose --project-name web-importer --file docker-compose.web-importer.yml  service down --cluster LEANDA  --aws-profile=${p};

ecs-cli compose --project-name chemical-export --file docker-compose.chemical-export.yml  service down --cluster LEANDA  --aws-profile=${p};
ecs-cli compose --project-name chemical-properties --file docker-compose.chemical-properties.yml   service down --cluster LEANDA  --aws-profile=${p};
ecs-cli compose --project-name spectra-parser --file docker-compose.spectra-parser.yml  service down --cluster LEANDA  --aws-profile=${p};
ecs-cli compose --project-name crystal-parser --file docker-compose.crystal-parser.yml  service down --cluster LEANDA  --aws-profile=${p};

ecs-cli compose --project-name reaction-parser --file docker-compose.reaction-parser.yml  service down --cluster LEANDA  --aws-profile=${p};
ecs-cli compose --project-name chemical-file-parser --file docker-compose.chemical-file-parser.yml   service down --cluster LEANDA  --aws-profile=${p};
ecs-cli compose --project-name metadata-processing --file docker-compose.metadata-processing.yml  service down --cluster LEANDA  --aws-profile=${p};
ecs-cli compose --project-name crystal-parser --file docker-compose.crystal-parser.yml  service down --cluster LEANDA  --aws-profile=${p};


ecs-cli compose --project-name imaging --file docker-compose.imaging.yml  service down --cluster LEANDA  --aws-profile=${p};
ecs-cli compose --project-name indexing --file docker-compose.indexing.yml   service down --cluster LEANDA  --aws-profile=${p};
ecs-cli compose --project-name webapi --file docker-compose.webapi.yml  service down --cluster LEANDA  --aws-profile=${p};
ecs-cli compose --project-name core-frontend --file docker-compose.core-frontend.yml  service down --cluster LEANDA  --aws-profile=${p};
ecs-cli compose --project-name core-backend --file docker-compose.core-backend.yml service down --cluster LEANDA  --aws-profile=${p};
ecs-cli compose --project-name sagahost --file docker-compose.sagahost.yml   service down --cluster LEANDA  --aws-profile=${p};
ecs-cli compose --project-name core-persistence --file docker-compose.core-persistence.yml  service down --cluster LEANDA  --aws-profile=${p};
ecs-cli compose --project-name eventstore --file docker-compose.eventstore.yml  service down --cluster LEANDA  --aws-profile=${p};
ecs-cli compose --project-name redis --file docker-compose.redis.yml  service down --cluster LEANDA  --aws-profile=${p};
ecs-cli compose --project-name rabbitmq --file docker-compose.rabbit.yml   service down --cluster LEANDA  --aws-profile=${p};
ecs-cli compose --project-name blob --file docker-compose.blob.yml  service down --cluster LEANDA  --aws-profile=${p};
ecs-cli compose --project-name mongo --file docker-compose.mongo.yml  service down --cluster LEANDA  --aws-profile=${p};
ecs-cli compose --project-name elastic --file docker-compose.elastic.yml  service down --cluster LEANDA --delete-namespace --aws-profile=${p};

echo "Removing main CloudFormation stack ..."

aws cloudformation delete-stack --stack-name LeandaLabWiz   --profile=${p}  || exit $?
