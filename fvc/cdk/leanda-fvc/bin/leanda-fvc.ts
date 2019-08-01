#!/usr/bin/env node
import 'source-map-support/register';
import cdk = require('@aws-cdk/core');
import { LeandaFvcStack } from '../lib/leanda-fvc-stack';

const app = new cdk.App();
new LeandaFvcStack(app, 'LeandaFvcStack');
