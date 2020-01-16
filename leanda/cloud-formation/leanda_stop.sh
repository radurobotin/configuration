#!/bin/bash


usage() { echo -e "This command requires that you have installes aws-cli, ecs-cli and jq. \n\nUsage: $0 [-s <stack_name>] [-p <aws_profile>] \nwhere: \n\t -p <aws_profile> is the name you have saved your AWS Credentials in ~/.aws/credentials.  \n\t -s <stack name> is the stack name to be removed" 1>&2; exit 1; }

while getopts ":s:p:" o; do
    case "${o}" in
        s)
            s=${OPTARG}
            ;;
        p)
            p=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done

shift $((OPTIND-1))

if  [ -z "${s}" ] || [ -z "${p}" ]; then
    usage
fi

DATE=`TZ=America/New_York date "+%Y-%m-%d %H:%M"`

echo "AWS-CLI profile selected:  ${p}. Start date-time: ${DATE}"
echo "Stack Name to be removed: ${s}"
PRIVATE_DNS=$(echo $s | tr '[:upper:]' '[:lower:]')
echo "Private DNS Domain name will be: ${PRIVATE_DNS}"

echo "Removing running containers from the stack..."


ecs-cli compose --project-name nginx --file docker-compose.nginx.yml service down --cluster ${s} --aws-profile=${p};

# echo "Removing other services..."

ecs-cli compose --project-name metadata-processing --file docker-compose.metadata-processing.yml service down --cluster ${s} --aws-profile=${p};
ecs-cli compose --project-name chemical-file-parser --file docker-compose.chemical-file-parser.yml service down --cluster ${s} --aws-profile=${p};
ecs-cli compose --project-name chemical-properties --file docker-compose.chemical-properties.yml service down --cluster ${s} --aws-profile=${p};
ecs-cli compose --project-name chemical-export --file docker-compose.chemical-export.yml service down --cluster ${s} --aws-profile=${p};
ecs-cli compose --project-name reaction-parser --file docker-compose.reaction-parser.yml service down --cluster ${s} --aws-profile=${p};
ecs-cli compose --project-name crystal-parser --file docker-compose.crystal-parser.yml service down --cluster ${s} --aws-profile=${p};
ecs-cli compose --project-name spectra-parser --file docker-compose.spectra-parser.yml service down --cluster ${s} --aws-profile=${p};
ecs-cli compose --project-name web-importer --file docker-compose.web-importer.yml service down --cluster ${s} --aws-profile=${p};
ecs-cli compose --project-name categories --file docker-compose.categories.yml service down --cluster ${s} --aws-profile=${p};
ecs-cli compose --project-name microscopy-metadata --file docker-compose.microscopy-metadata.yml service down --cluster ${s} --aws-profile=${p};

echo "Removing system secondary services..."

ecs-cli compose --project-name office-processor --file docker-compose.office-processor.yml service down --cluster ${s} --aws-profile=${p};
ecs-cli compose --project-name imaging --file docker-compose.imaging.yml service down --cluster ${s} --aws-profile=${p};
ecs-cli compose --project-name indexing --file docker-compose.indexing.yml service down --cluster ${s} --aws-profile=${p};

echo "Removing system core services..."

ecs-cli compose --project-name core-web-api --file docker-compose.core-web-api.yml service down --cluster ${s} --aws-profile=${p};
ecs-cli compose --project-name core-frontend --file docker-compose.core-frontend.yml service down --cluster ${s} --aws-profile=${p};
ecs-cli compose --project-name core-backend --file docker-compose.core-backend.yml service down --cluster ${s} --aws-profile=${p};
ecs-cli compose --project-name core-sagahost --file docker-compose.core-sagahost.yml service down --cluster ${s} --aws-profile=${p};
ecs-cli compose --project-name core-persistence --file docker-compose.core-persistence.yml service down --cluster ${s} --aws-profile=${p};
ecs-cli compose --project-name blob-storage-web-api --file docker-compose.blob-storage-web-api.yml service down --cluster ${s} --aws-profile=${p};

echo "Removing infrastructure services..."

ecs-cli compose --project-name eventstore --file docker-compose.eventstore.yml service down --cluster ${s} --aws-profile=${p};
ecs-cli compose --project-name redis --file docker-compose.redis.yml service down --cluster ${s} --aws-profile=${p};
ecs-cli compose --project-name rabbitmq --file docker-compose.rabbit.yml service down --cluster ${s} --aws-profile=${p};
ecs-cli compose --project-name mongo --file docker-compose.mongo.yml service down --cluster ${s} --aws-profile=${p};
ecs-cli compose --project-name elastic --file docker-compose.elastic.yml service down --cluster ${s} --delete-namespace --aws-profile=${p};

echo "Removing main CloudFormation stack ..."

aws cloudformation delete-stack --stack-name ${s}  --profile=${p} || exit $?
