#!/bin/bash
set -euxo pipefail

# The name of the stack
STACK_NAME="$1"
ARTIFACT_BUCKET="$2"
if [ "$#" -gt 2 ]; then
    SIMPLE_WORDS_CHANNEL="$3"
    SLACK_TOKEN="$4"
fi

aws cloudformation package \
    --template-file cloudformation.yml \
    --output-template-file cloudformation.out.yml \
    --s3-bucket "${ARTIFACT_BUCKET}"
if [ "$#" -gt 2 ]; then
    aws cloudformation deploy \
        --template-file cloudformation.out.yml \
        --stack-name "${STACK_NAME}" \
        --capabilities CAPABILITY_IAM \
        --parameter-overrides \
        "SimpleWordsChannel=${SIMPLE_WORDS_CHANNEL}" \
        "SlackToken=${SLACK_TOKEN}"
else
    aws cloudformation deploy \
        --template-file cloudformation.out.yml \
        --stack-name "${STACK_NAME}" \
        --capabilities CAPABILITY_IAM
fi

aws cloudformation describe-stacks --stack-name "${STACK_NAME}" \
    --query "Stacks[0].Outputs[?OutputKey=='WebhookUrl'].OutputValue" \
    --output text
