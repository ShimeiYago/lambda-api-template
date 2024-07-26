# Lambda API Template

This is a template for building REST APIs. It involves deploying a container to AWS ECR, using it to set up AWS Lambda, and creating a REST API.

## Table of Contents

- [Overview](#overview)
- [Setup](#setup)
- [Local Test](#local-test)
- [Deployment](#deployment)
- [Launch](#launch)
- [License](#license)
- [Author](#author)

## Overview

This template provides a basic setup for building REST APIs using AWS Lambda. By deploying a containerized application to AWS ECR (Elastic Container Registry) and using it with AWS Lambda, you can easily build a scalable REST API.

## Setup

1. **Download RIE**
```
curl -Lo aws-lambda-rie/aws-lambda-rie https://github.com/aws/aws-lambda-runtime-interface-emulator/releases/latest/download/aws-lambda-rie
```

```
chmod +x aws-lambda-rie/aws-lambda-rie
```

2. **Build image**
```
docker build -t lambda-api .
```

## Local Test

1. **Run Container**
```
docker run --rm -p 9000:8080 lambda-api:latest
```

Then POST `localhost:9000/2015-03-31/functions/function/invocations` is available.
(Request body is "{}" for template.)

## Deployment

1. **Set environment vriables**

```
REGION="ap-northeast-1"
ACCOUNTID=$(aws sts get-caller-identity --output text --query Account)
ECR_REPO_NAME="lambda-api"
```

1. **Create ECR Repository (Only first time)**

Please run this command only first time.

```
aws ecr create-repository --repository-name $ECR_REPO_NAME
```

2. **Add Docker tag**

```
docker tag lambda-api:latest ${ACCOUNTID}.dkr.ecr.${REGION}.amazonaws.com/${ECR_REPO_NAME}:latest
```

3. **Login**

```
aws ecr get-login-password --region ${REGION} | docker login --username AWS --password-stdin ${ACCOUNTID}.dkr.ecr.${REGION}.amazonaws.com
```

4. **Push Image**

```
docker push ${ACCOUNTID}.dkr.ecr.${REGION}.amazonaws.com/${ECR_REPO_NAME}:latest
```

## Launch (GUI)

1. **Create Lambda (Only first time)**

Create new AWS Lambda from GUI based on the deployed image.

2. **Connect to API Gateway (Only first time)**

Create new AWS API Gateway from GUI that connects to the lambda.

https://docs.aws.amazon.com/lambda/latest/dg/services-apigateway.html


## License

[MIT](https://github.com/tcnksm/tool/blob/master/LICENCE)

## Author

[ShimeiYago](https://github.com/ShimeiYago)