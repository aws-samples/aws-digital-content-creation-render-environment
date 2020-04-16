#!/usr/bin/env bash

# Import configuration
. ./main/.env

printf "\n--> Packaging and uploading templates to the %s S3 bucket ...\n" $BUCKET_NAME

aws cloudformation package \
  --template-file ./main/root.template \
  --s3-bucket $BUCKET_NAME \
  --s3-prefix $PREFIX_NAME \
  --output-template-file ./main/root-packaged.template

printf "\n--> Deploying %s template...\n" $STACK_NAME

aws cloudformation deploy \
  --template-file ./main/root-packaged.template \
  --stack-name $STACK_NAME \
  --region $AWS_REGION \
  --capabilities CAPABILITY_NAMED_IAM CAPABILITY_AUTO_EXPAND \
  --parameter-overrides \
    AvailabilityZones=${AWS_REGION}a,${AWS_REGION}b \
    EC2UserPassword=${EC2_USER_PASSWORD} \
    RenderNodeTargetCapacity=${RENDER_NODE_TARGET_CAPACITY} \
    RenderNodeInstanceType=${RENDER_NODE_INSTANCE_TYPE}
