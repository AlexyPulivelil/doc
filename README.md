**Document API** <br>
<br>
A simple file-processing placeholder API deployed on AWS using ECS Fargate, Terraform, Docker, and GitHub Actions.

The API has a single endpoint:

POST /process

Returns:

`` {"status": "ok", "filename": "<uploaded-file>"} ``

Services Used <br>
*Application*
1. FastAPI
2. Docker (containerization)

**CI/CD** <br>
1.GitHub Actions <br>
- Runs tests
- Builds Docker image
- Pushes image to Docker Hub
- Forces ECS to pull and deploy the new image

**AWS Infrastructure (provisioned via Terraform)**<br>
- ECS Fargate 
- Application Load Balancer
- VPC
- IAM Roles
- CloudWatch Log Group
- SSM Parameter Store
- S3 Backend for Terraform state

**Build Pipeline (CI)** <br> 
*Triggered on every push to main.*

Steps:
- Install Python dependencies
- Run tests using pytest
- Build Docker image
- Push image to Docker Hub
- Tag used:
``techino/doc-api:latest``

**Deploy Pipeline (CD)** <br>
- Force ECS Deployment
- aws ecs update-service --force-new-deployment
  <br>
<br> ECS then:
* Stops the old task
* Starts a new task
* Pulls the latest Docker image from Docker Hub
* Registers it behind the ALB

<br>

**Terraform resources already existed** <br>
This happened because I was not using Terraform from the pipeline and ran it manually without a backend.<br>
AWS resources were created, but Terraform had no state.<br>
Fix: Configure S3 backend → delete old infra → apply again cleanly.<br>

**ECS task failing due to missing SSM permissions**<br>
Error: ssm:GetParameters AccessDenied<br>
Fix: Attach correct IAM policy to ECS execution role (SSM readonly).<br>

**ALB showing 503** <br>
Tasks were unhealthy due to missing SSM permissions.<br>
Once fixed, ECS registered healthy targets.


