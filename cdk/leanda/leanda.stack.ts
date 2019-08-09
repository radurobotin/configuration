#!/usr/bin/env node
import 'source-map-support/register';
import cdk = require('@aws-cdk/core');
import route53 = require('@aws-cdk/aws-route53');
import s3 = require('@aws-cdk/aws-s3');
import ec2 = require('@aws-cdk/aws-ec2');
import { Construct } from '@aws-cdk/core';

import { environment as env } from './environment';

export class LeandaStack extends cdk.Stack {
    constructor(parent: Construct, name: string) {
        super(parent, name);

        new ec2.Vpc(this, `${env.stackName}-VPC`);

        const ipAddress = '';

        const zone = route53.HostedZone.fromHostedZoneId(this, `${env.stackName}-HostedZone`, env.domain);

        new route53.ARecord(this, `${env.stackName}-SiteAliasRecord`, {
            recordName: env.domain,
            target: route53.AddressRecordTarget.fromIpAddresses(ipAddress),
            zone
        });

        const siteDomain = env.subDomain + '.' + env.domain;

        // Content bucket
        new s3.Bucket(this, `${env.stackName}-SiteBucket`, {
            bucketName: siteDomain,
            websiteIndexDocument: 'index.html',
            websiteErrorDocument: 'error.html',
            publicReadAccess: true
        });
    }
}

const app = new cdk.App();

new LeandaStack(app, `${env.stackName}-LeandaStack`);
