# Local Development

This section details how to run the solution locally and deploy your code changes from the command line.

### Pre-Requisites

The following dependencies must be installed:

- AWS CLI
- Python >=3.8 and pip
- virtualenv

Once you have installed pre-requisites, clone the repository to your local machine and run the following command to create a `virtualenv` and install all dependencies.
```
make init
```

Activate `virtualenv` environment.
```
source venv/bin/activate
```

### Build and Deploy from Source

To deploy the solution manually from the source to your AWS account, run the
following:

1. Create a S3 bucket
   ```
   BUCKET_NAME="your-s3-bucket-name"
   AWS_REGION="aws-region(e.g. us-east-1)"
   aws s3 mb s3://${BUCKET_NAME} --region $AWS_REGION
   ```

1. Create an `.custom.mk` file and populate it with your own values
   ```
   cp .custom.mk.example .custom.mk
   ```
1. Deploy the stack
   ```
   make deploy
   ```

This will deploy the nested stack using the AWS CLI profile of the current shell. By default this will be the profile `default`.
