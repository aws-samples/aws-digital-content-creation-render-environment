#!/usr/bin/env bash

# Import configuration
. ./main/.env

printf "\n--> Deleting %s stack...\n" $STACK_NAME

aws cloudformation delete-stack \
    --stack-name $STACK_NAME

printf "\n--> $STACK_NAME deletion has been submitted, check AWS CloudFormation Console for an update..."
