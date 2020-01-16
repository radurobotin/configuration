set -e

usage() { echo -e "This command requires that you have installes aws-cli, ecs-cli and jq. \n\nUsage: $0 [-s <stack_name>] [-p <aws_profile>] \nwhere: \n\t -p <aws_profile> is the name you have saved your AWS Credentials in ~/.aws/credentials.  \n\t -s <stack name> is the stack name and will be inherited in most of the stack resources" 1>&2; exit 1; }

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
echo "Stack Name to be created: ${s}"

echo "Starting Cloud Formation Stack deployment ... This might take 15 minutes or more..."
aws cloudformation deploy --stack-name ${s} --template-file cf-backend.yml --capabilities CAPABILITY_IAM --profile=${p} --region=us-east-1 || exit $?

echo "Stack Deployment finished, preparing services..."

FARGATE_SG=`aws cloudformation describe-stacks  --stack-name ${s} --query "Stacks[0].Outputs[]"  --profile=${p} --region=us-east-1 --output json |jq -r '.[] | select(.OutputKey=="FargateSG") | .OutputValue'`
echo "Fargate Security Group name is:  ${FARGATE_SG}"

SUBNET1=`aws cloudformation describe-stacks  --stack-name ${s} --query "Stacks[0].Outputs[]"  --profile=${p} --region=us-east-1 --output json |jq -r '.[] | select(.OutputKey=="PrivateSubnetA") | .OutputValue'`
echo "First Private subnet: ${SUBNET1}"

SUBNET2=`aws cloudformation describe-stacks  --stack-name ${s} --query "Stacks[0].Outputs[]"  --profile=${p} --region=us-east-1 --output json |jq -r '.[] | select(.OutputKey=="PrivateSubnetB") | .OutputValue'`
echo "Second Private subnet: ${SUBNET2}"

PUB_SUBNET1=`aws cloudformation describe-stacks  --stack-name ${s} --query "Stacks[0].Outputs[]"  --profile=${p} --region=us-east-1 --output json |jq -r '.[] | select(.OutputKey=="PublicSubnetA") | .OutputValue'`
echo "First Public subnet: ${PUB_SUBNET1}"

PUB_SUBNET2=`aws cloudformation describe-stacks  --stack-name ${s} --query "Stacks[0].Outputs[]"  --profile=${p} --region=us-east-1 --output json |jq -r '.[] | select(.OutputKey=="PublicSubnetB") | .OutputValue'`
echo "Second Public subnet: ${PUB_SUBNET2}"

VPC=`aws cloudformation describe-stacks  --stack-name ${s} --query "Stacks[0].Outputs[]"  --profile=${p} --region=us-east-1 --output json |jq -r '.[] | select(.OutputKey=="VPC") | .OutputValue'`
echo "VPC: ${VPC}"

echo "Generating Config files..."

sed "s/I___SUBNET_1___I/$SUBNET1/g;s/I___SUBNET_2___I/$SUBNET2/g;s/I___FARGATE_SG___I/$FARGATE_SG/g" ecs-param.core.tmpl.yml >ecs-param.core.gen.yml
sed "s/I___SUBNET_1___I/$SUBNET1/g;s/I___SUBNET_2___I/$SUBNET2/g;s/I___FARGATE_SG___I/$FARGATE_SG/g" ecs-param.elastic.tmpl.yml >ecs-param.elastic.gen.yml
sed "s/I___SUBNET_1___I/$SUBNET1/g;s/I___SUBNET_2___I/$SUBNET2/g;s/I___FARGATE_SG___I/$FARGATE_SG/g" ecs-param.backend.tmpl.yml >ecs-param.backend.gen.yml
sed "s/I___PUB_SUBNET_1___I/$PUB_SUBNET1/g;s/I___PUB_SUBNET_2___I/$PUB_SUBNET2/g;s/I___FARGATE_SG___I/$FARGATE_SG/g" ecs-param.nginx.tmpl.yml >ecs-param.nginx.gen.yml

echo "Starting infrastructure services..."

ecs-cli compose --project-name elastic --file docker-compose.elastic.yml --ecs-params ecs-param.elastic.gen.yml service up --launch-type EC2 --create-log-groups --cluster ${s} --private-dns-namespace ${s} --vpc=${VPC} --enable-service-discovery --aws-profile=${p} ;
ecs-cli compose --project-name mongo --file docker-compose.mongo.yml --ecs-params ecs-param.backend.gen.yml service up --launch-type EC2 --create-log-groups --cluster ${s} --private-dns-namespace ${s} --vpc=${VPC} --enable-service-discovery --aws-profile=${p} ;
ecs-cli compose --project-name rabbitmq --file docker-compose.rabbit.yml --ecs-params ecs-param.backend.gen.yml service up --launch-type EC2 --create-log-groups --cluster ${s} --private-dns-namespace ${s} --vpc=${VPC} --enable-service-discovery --aws-profile=${p} ;
ecs-cli compose --project-name redis --file docker-compose.redis.yml --ecs-params ecs-param.backend.gen.yml service up --launch-type EC2 --create-log-groups --cluster ${s} --private-dns-namespace ${s} --vpc=${VPC} --enable-service-discovery --aws-profile=${p} ;
ecs-cli compose --project-name eventstore --file docker-compose.eventstore.yml --ecs-params ecs-param.backend.gen.yml service up --launch-type EC2 --create-log-groups --cluster ${s} --private-dns-namespace ${s} --vpc=${VPC} --enable-service-discovery --aws-profile=${p} ;

echo "Starting system core services..."

ecs-cli compose --project-name blob-storage-web-api --file docker-compose.blob-storage-web-api.yml --ecs-params ecs-param.backend.gen.yml service up --launch-type EC2 --create-log-groups --cluster ${s} --private-dns-namespace ${s} --vpc=${VPC} --enable-service-discovery --aws-profile=${p} ;
ecs-cli compose --project-name core-persistence --file docker-compose.core-persistence.yml --ecs-params ecs-param.core.gen.yml service up --launch-type FARGATE --create-log-groups --cluster ${s} --private-dns-namespace ${s} --vpc=${VPC} --enable-service-discovery --aws-profile=${p};
ecs-cli compose --project-name core-sagahost --file docker-compose.core-sagahost.yml --ecs-params ecs-param.core.gen.yml service up --launch-type FARGATE --create-log-groups --cluster ${s} --private-dns-namespace ${s} --vpc=${VPC} --enable-service-discovery --aws-profile=${p};
ecs-cli compose --project-name core-backend --file docker-compose.core-backend.yml --ecs-params ecs-param.core.gen.yml service up --launch-type FARGATE --create-log-groups --cluster ${s} --private-dns-namespace ${s} --vpc=${VPC} --enable-service-discovery --aws-profile=${p};
ecs-cli compose --project-name core-frontend --file docker-compose.core-frontend.yml --ecs-params ecs-param.core.gen.yml service up --launch-type FARGATE --create-log-groups --cluster ${s} --private-dns-namespace ${s} --vpc=${VPC} --enable-service-discovery --aws-profile=${p};
ecs-cli compose --project-name core-web-api --file docker-compose.core-web-api.yml --ecs-params ecs-param.core.gen.yml service up --launch-type FARGATE --create-log-groups --cluster ${s} --private-dns-namespace ${s} --vpc=${VPC} --enable-service-discovery --aws-profile=${p};

echo "Starting system secondary services..."

ecs-cli compose --project-name imaging --file docker-compose.imaging.yml --ecs-params ecs-param.core.gen.yml service up --launch-type FARGATE --create-log-groups --cluster ${s} --private-dns-namespace ${s} --vpc=${VPC} --enable-service-discovery --aws-profile=${p};
ecs-cli compose --project-name indexing --file docker-compose.indexing.yml --ecs-params ecs-param.core.gen.yml service up --launch-type FARGATE --create-log-groups --cluster ${s} --private-dns-namespace ${s} --vpc=${VPC} --enable-service-discovery --aws-profile=${p};
ecs-cli compose --project-name office-processor --file docker-compose.office-processor.yml --ecs-params ecs-param.core.gen.yml service up --launch-type FARGATE --create-log-groups --cluster ${s} --private-dns-namespace ${s} --vpc=${VPC} --enable-service-discovery --aws-profile=${p};

echo "Starting other services..."

ecs-cli compose --project-name metadata-processing --file docker-compose.metadata-processing.yml --ecs-params ecs-param.core.gen.yml service up --launch-type FARGATE --create-log-groups --cluster ${s} --private-dns-namespace ${s} --vpc=${VPC} --enable-service-discovery --aws-profile=${p};
ecs-cli compose --project-name chemical-file-parser --file docker-compose.chemical-file-parser.yml --ecs-params ecs-param.core.gen.yml service up --launch-type FARGATE --create-log-groups --cluster ${s} --private-dns-namespace ${s} --vpc=${VPC} --enable-service-discovery --aws-profile=${p};
ecs-cli compose --project-name chemical-properties --file docker-compose.chemical-properties.yml --ecs-params ecs-param.core.gen.yml service up --launch-type FARGATE --create-log-groups --cluster ${s} --private-dns-namespace ${s} --vpc=${VPC} --enable-service-discovery --aws-profile=${p};
ecs-cli compose --project-name chemical-export --file docker-compose.chemical-export.yml --ecs-params ecs-param.core.gen.yml service up --launch-type FARGATE --create-log-groups --cluster ${s} --private-dns-namespace ${s} --vpc=${VPC} --enable-service-discovery --aws-profile=${p};
ecs-cli compose --project-name reaction-parser --file docker-compose.reaction-parser.yml --ecs-params ecs-param.core.gen.yml service up --launch-type FARGATE --create-log-groups --cluster ${s} --private-dns-namespace ${s} --vpc=${VPC} --enable-service-discovery --aws-profile=${p};
ecs-cli compose --project-name crystal-parser --file docker-compose.crystal-parser.yml --ecs-params ecs-param.core.gen.yml service up --launch-type FARGATE --create-log-groups --cluster ${s} --private-dns-namespace ${s} --vpc=${VPC} --enable-service-discovery --aws-profile=${p};
ecs-cli compose --project-name spectra-parser --file docker-compose.spectra-parser.yml --ecs-params ecs-param.core.gen.yml service up --launch-type FARGATE --create-log-groups --cluster ${s} --private-dns-namespace ${s} --vpc=${VPC} --enable-service-discovery --aws-profile=${p};
ecs-cli compose --project-name web-importer --file docker-compose.web-importer.yml --ecs-params ecs-param.core.gen.yml service up --launch-type FARGATE --create-log-groups --cluster ${s} --private-dns-namespace ${s} --vpc=${VPC} --enable-service-discovery --aws-profile=${p};
ecs-cli compose --project-name microscopy-metadata --file docker-compose.microscopy-metadata.yml --ecs-params ecs-param.core.gen.yml service up --launch-type FARGATE --create-log-groups --cluster ${s} --private-dns-namespace ${s} --vpc=${VPC} --enable-service-discovery --aws-profile=${p};
ecs-cli compose --project-name categories --file docker-compose.categories.yml --ecs-params ecs-param.core.gen.yml service up --launch-type FARGATE --create-log-groups --cluster ${s} --private-dns-namespace ${s} --vpc=${VPC} --enable-service-discovery --aws-profile=${p};

echo "Starting proxy service..."

ecs-cli compose --project-name nginx --file docker-compose.nginx.yml --ecs-params ecs-param.nginx.gen.yml service up --launch-type FARGATE --create-log-groups --cluster ${s} --private-dns-namespace ${s} --vpc=${VPC} --enable-service-discovery --aws-profile=${p};


