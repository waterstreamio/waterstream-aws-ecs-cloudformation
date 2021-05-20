Waterstream - AWS ECS CloudFormation scripts
============================================

Overview
--------

This repository contains CloudFormation scripts for [Waterstream](waterstream.io) deploy. 
More specifically, they do the following:

- Create VPC with 3 private and 3 public subnets
- (optionally) deploy Kafka with AWS MSK into the private subnets
- Create Kafka topics required for Waterstream 
- Deploy Waterstream with AWS ECS into the private subnets
- Create MQTT load balancer in the public subnets to which MQTT clients can connect over the internet
- (optionally) protect MQTT traffic with SSL/TLS, including client authentication 
- Deploy Prometheus and Grafana with AWS ECS, configure them to fetch metrics from Waterstream
- Expose Grafana with a load balancer in the public subnets  
- Launch a testbox - small EC2 instance that has command-line MQTT clients properly configured
  to connect to Waterstream. If SSL/TLS enabled for Waterstream, the testbox is also responsible
  for creating the local Certificate Authority and issuing certificates for the Waterstream and its clients.

[Quickstart guide](QUICKSTART.md) explains how to run these scripts though AWS Console UI, with minimal upfront effort.
This document explains command-line options and more detailed topics.

Pre-requisites
--------------

- [AWS Marketplace subscription](https://aws.amazon.com/marketplace/pp/B08ZDMBQY5) for Waterstream from your AWS account
- If installing with CLI - AWS CLI installed on your machine (https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
  Write down the AWS CLI profile name you're going to use for the Waterstream deploy.
- Keypair for SSH-ing from your machine into the testbox configured in your AWS account. Write down its name. 
- DockerHub credentials configured in AWS Secret Manager - anonymous access exceeds pull limits too fast. 
  See https://docs.aws.amazon.com/AmazonECS/latest/developerguide/private-auth.html#private-auth-enable for 
  the details of the secret creation. Free DockerHub account is sufficient if you aren't deploying too often.

Authorizations for the user that makes the deploy
-------------------------------------------------

Managed policies:

- `arn:aws:iam::aws:policy/AmazonMSKFullAccess` (if you're going to deploy MSK Kafka)
- `arn:aws:iam::aws:policy/AmazonECS_FullAccess` 

Custom policies:

- You may use [WaterstreamCfEcsDeploy.json](WaterstreamCfEcsDeploy.json) policy to grant permissions
  for managing VPC, IAM roles, CloudWatch logs, testbox EC2 instance, etc. 
- Grant access to the DockerHub credentials secret. Example policy:

      {
        "Version": "2012-10-17",
        "Statement": [{
          "Sid": "VisualEditor0",
          "Effect": "Allow",
          "Action": [
            "secretsmanager:GetSecretValue",
            "secretsmanager:DescribeSecret"
          ],
          "Resource": "arn:aws:secretsmanager:*:<your AWS account>:secret:<your secret>"
        }]
      }

Deploying 
---------

If you'd like to deploy with AWS Console UI - please refer to the [quickstart guide](QUICKSTART.md).
If you'd like to deploy with CLI - please follow the following instructions:

- Copy and customize config file:

      cp config.sh.example config.sh

- Create all the stacks:

      ./create_all.sh

  Or selectively, checking that the previous stack has completed before deploying the next one:

      ./create_commons.sh
      ./create_kafka.sh
      ./create_waterstream.sh


Testing the deploy
------------------

Get the output parameters or `waterstream-waterstream` stack with AWS Console UI or with this script:

    ./get_waterstream_output.sh

To open the Waterstream dashboard: copy `WaterstreamGrafanaLbHostname`, open in web browser with port `3000`, 
click "Dashboards/Manage" in the left panel, then click "Waterstream" dashboard.

To log into the testbox: copy `WaterstreamTestboxHostname`, ssh into that machine like this in 2 terminals:

    ssh -i <path to identity file> ec2-user@<value from WaterstreamTestboxHostname>

If you're running plain-text Waterstream (i.e. no SSL/TLS), run `plain/mqtt_receive_sample.sh` in one terminal
and `plain/mqtt_send_sample.sh` in another. You should see the sample message in the receiving side.
If you're runnning with SSL/TLS - use `tls/mqtt_receive_sample.sh` and `tls/mqtt_send_sample.sh` instead.
In the dashboard you'll see the number of sent/received messages going up.

The `local_scripts` folder contains various useful scripts for connecting to Waterstream from the local machine,
issuing the new client certificates etc.

Undeploying 
-----------

Delete all the stacks:

    ./destroy_all.sh

Or individually:

    ./destroy_waterstream.sh
    ./destroy_kafka.sh
    #Check in AWS Console that the previous two are deleted before running this one:
    ./destroy_commons.sh

Support
-------

You can get the support on [Waterstream Dev forum](https://dev.waterstream.io/). 
Feel free to write there if you have any questions.