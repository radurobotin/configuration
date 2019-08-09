# Leanda.io Stack

## Creates

* VPC with one public subnet
* Internet Gateway
* EC2 Spot Fleet
* Route53 alias record for the API
* S3 bucket for the front-end

## Configuration

    domainName: 'leanda.io',
    siteSubDomain: 'fvc',
    stackName: 'FVC',
    availabilityZone: 'us-east-1f'

## Useful commands

* `npm run build`   compile typescript to js
* `npm run watch`   watch for changes and compile
* `cdk deploy`      deploy this stack to your default AWS account/region
* `cdk diff`        compare deployed stack with current state
* `cdk synth`       emits the synthesized CloudFormation template
