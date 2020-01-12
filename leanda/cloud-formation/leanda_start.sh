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
echo "Starting Cloud Formation Stack deployment ... This might take 15 minutes or more..."
aws cloudformation deploy --stack-name LeandaLabWiz --template-file cf-backend.yml --capabilities CAPABILITY_IAM --profile=${p} --region=us-east-1 || exit $?

echo "Stack Deployment finished, preparing services ... "

FARGATE_SG=`aws cloudformation describe-stacks  --stack-name LeandaLabWiz --query "Stacks[0].Outputs[]"  --profile=${p} --region=us-east-1 --output json |jq -r '.[] | select(.OutputKey=="FargateSG") | .OutputValue'`
echo "Fargate Security Group name is:  ${FARGATE_SG}"

SUBNET1=`aws cloudformation describe-stacks  --stack-name LeandaLabWiz --query "Stacks[0].Outputs[]"  --profile=${p} --region=us-east-1 --output json |jq -r '.[] | select(.OutputKey=="PrivateSubnetA") | .OutputValue'`
echo "First Private subnet: ${SUBNET1}"

SUBNET2=`aws cloudformation describe-stacks  --stack-name LeandaLabWiz --query "Stacks[0].Outputs[]"  --profile=${p} --region=us-east-1 --output json |jq -r '.[] | select(.OutputKey=="PrivateSubnetB") | .OutputValue'`
echo "Second Private subnet: ${SUBNET2}"
VPC=`aws cloudformation describe-stacks  --stack-name LeandaLabWiz --query "Stacks[0].Outputs[]"  --profile=${p} --region=us-east-1 --output json |jq -r '.[] | select(.OutputKey=="VPC") | .OutputValue'`
echo "VPC: ${VPC}"

echo "Generating Config files ... "

sed "s/I___SUBNET_1___I/$SUBNET1/g;s/I___SUBNET_2___I/$SUBNET2/g;s/I___FARGATE_SG___I/$FARGATE_SG/g" ecs-param.core.tmpl.yml >ecs-param.core.gen.yml
sed "s/I___SUBNET_1___I/$SUBNET1/g;s/I___SUBNET_2___I/$SUBNET2/g;s/I___FARGATE_SG___I/$FARGATE_SG/g" ecs-param.elastic.tmpl.yml >ecs-param.elastic.gen.yml
sed "s/I___SUBNET_1___I/$SUBNET1/g;s/I___SUBNET_2___I/$SUBNET2/g;s/I___FARGATE_SG___I/$FARGATE_SG/g" ecs-param.backend.tmpl.yml >ecs-param.backend.gen.yml

#ecs-cli compose --project-name elastic --file docker-compose.elastic.yml --ecs-params ecs-param.elastic.gen.yml service up --launch-type EC2 --create-log-groups  --cluster LEANDA --private-dns-namespace leanda  --vpc=${VPC} --enable-service-discovery  --aws-profile=${p} ;

# ecs-cli compose --project-name mongo --file docker-compose.mongo.yml --ecs-params ecs-param.backend.gen.yml service up --launch-type EC2 --create-log-groups  --cluster LEANDA --private-dns-namespace leanda  --vpc=${VPC} --enable-service-discovery  --aws-profile=${p} ;
# ecs-cli compose --project-name blob-storage-webapi --file docker-compose.blob-storage-webapi.yml --ecs-params ecs-param.backend.gen.yml service up --launch-type EC2 --create-log-groups  --cluster LEANDA --private-dns-namespace leanda  --vpc=${VPC} --enable-service-discovery  --aws-profile=${p} ;
# ecs-cli compose --project-name rabbitmq --file docker-compose.rabbit.yml --ecs-params ecs-param.backend.gen.yml service up --launch-type EC2 --create-log-groups  --cluster LEANDA --private-dns-namespace leanda  --vpc=${VPC} --enable-service-discovery  --aws-profile=${p} ;
# ecs-cli compose --project-name redis --file docker-compose.redis.yml --ecs-params ecs-param.backend.gen.yml service up --launch-type EC2 --create-log-groups  --cluster LEANDA --private-dns-namespace leanda  --vpc=${VPC} --enable-service-discovery  --aws-profile=${p} ;
# ecs-cli compose --project-name eventstore --file docker-compose.eventstore.yml --ecs-params ecs-param.backend.gen.yml service up --launch-type EC2 --create-log-groups  --cluster LEANDA --private-dns-namespace leanda  --vpc=${VPC} --enable-service-discovery  --aws-profile=${p} ;

ecs-cli compose --project-name core-persistence --file docker-compose.core-persistence.yml --ecs-params ecs-param.core.gen.yml service up --launch-type FARGATE --create-log-groups  --cluster LEANDA --private-dns-namespace leanda  --vpc=${VPC} --enable-service-discovery  --aws-profile=${p};
ecs-cli compose --project-name sagahost --file docker-compose.sagahost.yml --ecs-params ecs-param.core.gen.yml service up --launch-type FARGATE --create-log-groups  --cluster LEANDA --private-dns-namespace leanda  --vpc=${VPC} --enable-service-discovery  --aws-profile=${p};
ecs-cli compose --project-name core-backend --file docker-compose.core-backend.yml --ecs-params ecs-param.core.gen.yml service up --launch-type FARGATE --create-log-groups  --cluster LEANDA --private-dns-namespace leanda  --vpc=${VPC} --enable-service-discovery  --aws-profile=${p};
ecs-cli compose --project-name core-frontend --file docker-compose.core-frontend.yml --ecs-params ecs-param.core.gen.yml service up --launch-type FARGATE --create-log-groups  --cluster LEANDA --private-dns-namespace leanda  --vpc=${VPC} --enable-service-discovery  --aws-profile=${p};
ecs-cli compose --project-name core-webapi --file docker-compose.core-webapi.yml --ecs-params ecs-param.core.gen.yml service up --launch-type FARGATE --create-log-groups  --cluster LEANDA --private-dns-namespace leanda  --vpc=${VPC} --enable-service-discovery  --aws-profile=${p};
ecs-cli compose --project-name indexing --file docker-compose.indexing.yml --ecs-params ecs-param.core.gen.yml service up --launch-type FARGATE --create-log-groups  --cluster LEANDA --private-dns-namespace leanda  --vpc=${VPC} --enable-service-discovery  --aws-profile=${p};
ecs-cli compose --project-name imaging --file docker-compose.imaging.yml --ecs-params ecs-param.core.gen.yml service up --launch-type FARGATE --create-log-groups  --cluster LEANDA --private-dns-namespace leanda  --vpc=${VPC} --enable-service-discovery  --aws-profile=${p};

ecs-cli compose --project-name office-processor --file docker-compose.office-processor.yml --ecs-params ecs-param.core.gen.yml service up --launch-type FARGATE --create-log-groups  --cluster LEANDA --private-dns-namespace leanda  --vpc=${VPC} --enable-service-discovery  --aws-profile=${p};

ecs-cli compose --project-name metadata-processing --file docker-compose.metadata-processing.yml --ecs-params ecs-param.core.gen.yml service up --launch-type FARGATE --create-log-groups  --cluster LEANDA --private-dns-namespace leanda  --vpc=${VPC} --enable-service-discovery  --aws-profile=${p};
ecs-cli compose --project-name chemical-file-parser --file docker-compose.chemical-file-parser.yml --ecs-params ecs-param.core.gen.yml service up --launch-type FARGATE --create-log-groups  --cluster LEANDA --private-dns-namespace leanda  --vpc=${VPC} --enable-service-discovery  --aws-profile=${p};
ecs-cli compose --project-name reaction-parser --file docker-compose.reaction-parser.yml --ecs-params ecs-param.core.gen.yml service up --launch-type FARGATE --create-log-groups  --cluster LEANDA --private-dns-namespace leanda  --vpc=${VPC} --enable-service-discovery  --aws-profile=${p};
ecs-cli compose --project-name crystal-parser --file docker-compose.crystal-parser.yml --ecs-params ecs-param.core.gen.yml service up --launch-type FARGATE --create-log-groups  --cluster LEANDA --private-dns-namespace leanda  --vpc=${VPC} --enable-service-discovery  --aws-profile=${p};
ecs-cli compose --project-name spectra-parser --file docker-compose.spectra-parser.yml --ecs-params ecs-param.core.gen.yml service up --launch-type FARGATE --create-log-groups  --cluster LEANDA --private-dns-namespace leanda  --vpc=${VPC} --enable-service-discovery  --aws-profile=${p};
ecs-cli compose --project-name chemical-properties --file docker-compose.chemical-properties.yml --ecs-params ecs-param.core.gen.yml service up --launch-type FARGATE --create-log-groups  --cluster LEANDA --private-dns-namespace leanda  --vpc=${VPC} --enable-service-discovery  --aws-profile=${p};
ecs-cli compose --project-name chemical-export --file docker-compose.chemical-export.yml --ecs-params ecs-param.core.gen.yml service up --launch-type FARGATE --create-log-groups  --cluster LEANDA --private-dns-namespace leanda  --vpc=${VPC} --enable-service-discovery  --aws-profile=${p};

ecs-cli compose --project-name web-importer --file docker-compose.web-importer.yml --ecs-params ecs-param.core.gen.yml service up --launch-type FARGATE --create-log-groups  --cluster LEANDA --private-dns-namespace leanda  --vpc=${VPC} --enable-service-discovery  --aws-profile=${p};
ecs-cli compose --project-name microscopy-metadata --file docker-compose.microscopy-metadata.yml --ecs-params ecs-param.core.gen.yml service up --launch-type FARGATE --create-log-groups  --cluster LEANDA --private-dns-namespace leanda  --vpc=${VPC} --enable-service-discovery  --aws-profile=${p};
ecs-cli compose --project-name categories --file docker-compose.categories.yml --ecs-params ecs-param.core.gen.yml service up --launch-type FARGATE --create-log-groups  --cluster LEANDA --private-dns-namespace leanda  --vpc=${VPC} --enable-service-discovery  --aws-profile=${p};

ecs-cli compose --project-name nginx --file docker-compose.nginx.yml --ecs-params ecs-param.core.gen.yml service up --launch-type FARGATE --create-log-groups  --cluster LEANDA --private-dns-namespace leanda  --vpc=${VPC} --enable-service-discovery  --aws-profile=${p};