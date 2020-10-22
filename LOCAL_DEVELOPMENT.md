# Local Development

This section details how to run the solution locally and deploy your code changes from the command line.

### Pre-Requisites

The following dependencies must be installed:

- AWS CLI
- Python >=3.8 and pip
- virtualenv

### Build and Deploy from Source
To deploy the solution manually from the source to your AWS account, run the following:

1. Set the env variables
    ```shell script
    BUCKET_NAME=""
    AWS_REGION=""
    ```
1. Create S3 bucket
    ```shell script
    aws s3 mb s3://${BUCKET_NAME} --region ${AWS_REGION}
    ```
1. Create a `.custom.mk` file and populate it with your own values
    ```shell script
    cp .custom.mk.example .custom.mk
    ```
    |Variable Label|Example|Description|
    |--------------|-------|-----------|
    |AWS_REGION|eu-west-1|The AWS region to deploy the solution to|
    |BUCKET_NAME|my-unique-bucket-name|Use the same value from step above|
    |STACK_NAME|aws-dcc|The name of the stack|
    |CREATE_VPN_ENDPOINT|true|Determinate whatever Client VPN will be created|
    |SERVER_CERT_ARN|arn:aws:acm:xxxxx|Server ACM certificate ARN|
    |CLIENT_CERT_ARN|arn:aws:acm:xxxxx|Client ACM certificate ARN|
    |WORKSTATION_SUBNET_PLACEMENT|Private|Set to private if Client VPN is set to true|
    |EC2_USER_PASSWORD|MyStrongPassword|Password to access workstation|
    |RENDER_NODE_TARGET_CAPACITY|2|How many nodes to deploy?|
    |RENDER_NODE_INSTANCE_TYPE|c5.4xlarge,c4.4xlarge|Type of render node instances|
1. Initialize the local environment
    ```shell script
    make init
    ```
1. Activate `virtualenv` environment.
    ```shell script
    source venv/bin/activate
    ```

### Deploy the stack
This will deploy the nested stack using the AWS CLI profile of the current shell. By default this will be the profile `default`.
```shell script
make deploy
```

### Test changes
The following command will run `pre-commit` tests. This should be run before every new commit.
```shell script
make test
```

### Clean the virtual environment
This command will delete the virtual environment and all installed packages install via `make init`
```shell script
make clean
```

### Delete the resources created via CloudFormation
Below command will delete deployed stack
```shell script
make delete
```
