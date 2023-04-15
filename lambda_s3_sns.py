#!/usr/bin/env python3
#  coding=utf-8
#  [% VIM_TAGS %]
#
#  Author: Hari Sekhon
#  Date: [% DATE # 2020-12-14 23:43:05 +0000 (Mon, 14 Dec 2020) %]
#
#  [% URL %]
#
#  [% LICENSE %]
#
#  [% MESSAGE %]
#
#  [% LINKEDIN %]
#

# Receives a Lambda event from S3, parses it, prints it to CloudWatch logs and
# publishes an SNS message to trigger a notification via email or whatever SNS is configured to do

# This Lambda is triggered by the adjacent s3_bucket_lambda_trigger.json and requires a bunch of IAM permissions

# pylint: disable=fixme,superfluous-parens,unused-argument,unused-variable
# XXX: remove this

import boto3

def lambda_handler(event, context):
    client = boto3.client('sns')

    try:
        size = event['Records'][0]['s3']['object']['size']
    except KeyError:
        pass
    bucket = event['Records'][0]['s3']['bucket']['name']
    key = event['Records'][0]['s3']['object']['key']
    if event['Records'][0]['eventName'] == "ObjectRemoved:Delete":
        payload_str = "An object with name: " + key + " was deleted from bucket: " + bucket
    else:
        payload_str = "An object with name " + key + " and size "+ str(size) + "B was uploaded to bucket: " + bucket

    print(payload_str)

    # requires SNS topic to already exist and be configured with subscriptions to get this notification
    response = client.publish(
        # XXX: replace this topic arn with your real one
        TopicArn='arn:aws:sns:us-east-1:453236102806:LambdaTopic',
        Message=payload_str,
        # XXX: replace subject
        Subject='My Lambda S3 event'
    )
