SHELL := /bin/bash

.PHONY : help init deploy test clean delete
.DEFAULT: help

# Check for .custom.mk file if exists
CUSTOM_FILE ?= .custom.mk
CUSTOM_EXAMPLE ?= .custom.mk.example
ifneq ("$(wildcard $(CUSTOM_FILE))","")
	include $(CUSTOM_FILE)
else ifneq ("$(wildcard $(CUSTOM_EXAMPLE))","")
	include $(CUSTOM_EXAMPLE)
else
$(error File `.custom.mk` doesnt exist, please create one.)
endif

help:
	@echo "init 		generate project for local development"
	@echo "deploy 		deploy solution from source"
	@echo "test 		run pre-commit checks"
	@echo "clean 		delete virtualenv and installed libraries"
	@echo "delete 		delete deployed stacks"

# Install local dependencies and git hooks
init: venv
	venv/bin/pre-commit install

deploy: package
	@printf "\n--> Deploying %s template...\n" $(STACK_NAME)
	@aws cloudformation deploy \
	  --template-file ./cfn/packaged.template \
	  --stack-name $(STACK_NAME) \
	  --region $(AWS_REGION) \
	  --capabilities CAPABILITY_NAMED_IAM CAPABILITY_AUTO_EXPAND \
	  --parameter-overrides \
	  	AvailabilityZones=$(AWS_REGION)a,$(AWS_REGION)b \
	  	EC2UserPassword=$(EC2_USER_PASSWORD) \
	  	RenderNodeTargetCapacity=$(RENDER_NODE_TARGET_CAPACITY) \
	  	WorkstationAccessCIDR=$(WORKSTATION_ACCESS_CIDR) \
	  	WorkstationConnectionManager=$(WORKSTATION_CONNECTION_MANAGER) \
	  	CreateVPNEndpoint=$(CREATE_VPN_ENDPOINT) \
	  	ServerCertificateArn=$(SERVER_CERT_ARN) \
	  	ClientCertificateArn=$(CLIENT_CERT_ARN)

package:
	@printf "\n--> Packaging and uploading templates to the %s S3 bucket ...\n" $(BUCKET_NAME)
	@aws cloudformation package \
  	--template-file ./cfn/main.template \
  	--s3-bucket $(BUCKET_NAME) \
  	--s3-prefix $(STACK_NAME) \
  	--output-template-file ./cfn/packaged.template \
  	--region $(AWS_REGION)

# Package for cfn-publish CI
cfn-publish-package:
	zip -r packaged.zip -@ < ci/include.lst

# virtualenv setup
venv: venv/bin/activate

venv/bin/activate: requirements.txt
	test -d venv || virtualenv venv
	. venv/bin/activate; pip install -Ur requirements.txt
	touch venv/bin/activate

test:
	pre-commit run --all-files

version:
	@bumpversion --dry-run --list cfn/main.template | grep current_version | sed s/'^.*='//

# Cleanup local build
clean:
	rm -rf venv
	find . -iname "*.pyc" -delete

delete:
	@printf "\n--> Deleting %s stack...\n" $(STACK_NAME)
	@aws cloudformation delete-stack \
            --stack-name $(STACK_NAME)
	@printf "\n--> $(STACK_NAME) deletion has been submitted, check AWS CloudFormation Console for an update..."
