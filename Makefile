APP_NAME = lambda/lambda-postgresql
FUNCTION_NAME = lambda-postgresql-sandbox
APP_VERSION ?=

AWS_ECR_ACCOUNT_ID ?=
AWS_ECR_REGION ?=
AWS_ECR_REPO = $(APP_NAME)

TAG ?= latest


.PHONY : docker/build docker/push docker/run/bash

docker/build :
	docker build -t $(APP_NAME):$(APP_VERSION) .


docker/push : docker/build
	aws ecr get-login-password --region $(AWS_ECR_REGION) | docker login --username AWS --password-stdin $(AWS_ECR_ACCOUNT_ID).dkr.ecr.$(AWS_ECR_REGION).amazonaws.com
	docker tag $(APP_NAME):$(APP_VERSION) $(AWS_ECR_ACCOUNT_ID).dkr.ecr.$(AWS_ECR_REGION).amazonaws.com/$(AWS_ECR_REPO):$(TAG)
	docker push $(AWS_ECR_ACCOUNT_ID).dkr.ecr.$(AWS_ECR_REGION).amazonaws.com/$(AWS_ECR_REPO):$(TAG)
	aws lambda update-function-code --function-name $(FUNCTION_NAME) --image-uri $(AWS_ECR_ACCOUNT_ID).dkr.ecr.$(AWS_ECR_REGION).amazonaws.com/$(AWS_ECR_REPO):$(TAG) --publish || true


docker/run/bash :
	docker run --rm -it -w /var/task --entrypoint /bin/bash $(APP_NAME):$(APP_VERSION)
