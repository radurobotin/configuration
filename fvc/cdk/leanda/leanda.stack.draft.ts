#!/usr/bin/env node
import 'source-map-support/register';
import cdk = require('@aws-cdk/core');
import cloudfront = require('@aws-cdk/aws-cloudfront');
import route53 = require('@aws-cdk/aws-route53');
import s3 = require('@aws-cdk/aws-s3');
import acm = require('@aws-cdk/aws-certificatemanager');
import targets = require('@aws-cdk/aws-route53-targets/lib');
import ec2 = require('@aws-cdk/aws-ec2');
import elbv2 = require('@aws-cdk/aws-elasticloadbalancingv2');
import { Construct } from '@aws-cdk/core';

import { environment as env } from './environment';

export class LeandaStack extends cdk.Stack {
    constructor(parent: Construct, name: string) {
        super(parent, name);

        const siteDomain = env.subDomain + '.' + env.domain;

        // Content bucket
        const siteBucket = new s3.Bucket(this, `${env.stackName}-SiteBucket`, {
            bucketName: siteDomain,
            websiteIndexDocument: 'index.html',
            websiteErrorDocument: 'error.html',
            publicReadAccess: true
        });

        new cdk.CfnOutput(this, 'Bucket', { value: siteBucket.bucketName });

        // Pre-existing ACM certificate, with the ARN stored in an SSM Parameter
        const certificateArn = new acm.Certificate(this, `${env.stackName}-ArnParameter`, {
            domainName: env.domain
        }).certificateArn;

        // CloudFront distribution that provides HTTPS
        const distribution = new cloudfront.CloudFrontWebDistribution(this, `${env.stackName}-SiteDistribution`, {
            aliasConfiguration: {
                acmCertRef: certificateArn,
                names: [siteDomain],
                sslMethod: cloudfront.SSLMethod.SNI,
                securityPolicy: cloudfront.SecurityPolicyProtocol.TLS_V1_1_2016,
            },
            originConfigs: [
                {
                    s3OriginSource: {
                        s3BucketSource: siteBucket
                    },
                    behaviors: [{ isDefaultBehavior: true }],
                }
            ]
        });

        new cdk.CfnOutput(this, `${env.stackName}-Distribution`, { value: distribution.distributionId });

        /**
         * NOTE: the code below is not transpiling properly to JavaScript
         * Pending review by AWS team
         */

        // Route53 alias record for the CloudFront distribution
        const zone = new route53.HostedZone(this, `${env.stackName}-HostedZone`, {
            zoneName: env.domain
        });
        new route53.ARecord(this, `${env.stackName}-SiteAliasRecord`, {
            recordName: siteDomain,
            target: route53.AddressRecordTarget.fromAlias(new targets.CloudFrontTarget(distribution)),
            zone
        });

        const vpc = new ec2.Vpc(this, `${env.stackName}-VPC`);

        const lb = new elbv2.ApplicationLoadBalancer(this, `${env.stackName}-LB`, {
            vpc,
            internetFacing: true
        });

        const listener = lb.addListener(`${env.stackName}-Listener`, {
            port: 80,
        });

        listener.addTargets('Target', {
            port: 80
        });

        listener.connections.allowDefaultPortFromAnyIpv4('Open to the world');

    }
}

const app = new cdk.App();

new LeandaStack(app, `${env.stackName}-LeandaStack`);
