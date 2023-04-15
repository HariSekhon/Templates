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

# Receives a Lambda events from SNS subscription, prints to CloudWatch logs and returns it

import os

# https://docs.aws.amazon.com/lambda/latest/dg/python-handler.html
def lambda_handler(event, context):
    message = event['Records'][0]['Sns']['Message']
    print("event:", event)
    print("env:", os.environ)
    # https://docs.aws.amazon.com/lambda/latest/dg/python-context.html
    #print("SNS context:", dir(context))
    print("Lambda function ARN:", context.invoked_function_arn)
    print("CloudWatch log stream name:", context.log_stream_name)
    print("CloudWatch log group name:", context.log_group_name)
    print("Lambda Request ID:", context.aws_request_id)
    print("Lambda function memory limits in MB:", context.memory_limit_in_mb)
    print("SNS Message:", message)
    return message
