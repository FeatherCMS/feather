# AWS Infrastructure

This document defines the AWS resources required by the ECS deployment.

## 1) Compute

- ECS cluster per environment, or an explicitly isolated shared cluster.
- EC2 Auto Scaling Group in at least two Availability Zones.
- ECS-optimized Linux AMI through a launch template.
- ECS capacity provider attached to the Auto Scaling Group.
- Private subnets for ECS instances and RDS.
- Public subnets only for the Application Load Balancer and controlled egress components.

The EC2 instances require an instance profile that permits ECS registration, ECR image pulls, CloudWatch logging, and SSM management. Application permissions belong to the ECS task role, not the instance role.

## 2) Networking

Required security-group boundaries:

- ALB accepts HTTPS from the intended clients.
- ECS services accept only the required application ports from the ALB or internal service sources.
- RDS accepts PostgreSQL traffic only from the ECS service security group.
- ECS instances do not expose SSH to the public internet. Use SSM Session Manager for administration.

The target ports must match the executable configuration. The repository currently exposes health routes in the HTTP runtimes; the final port values belong in the environment-specific task definitions.

## 3) Storage and services

- Amazon ECR repositories for each runtime image, with image scanning and lifecycle retention.
- Amazon RDS for PostgreSQL with automated backups, encryption, and multi-AZ configuration appropriate to the environment.
- AWS Secrets Manager or SSM Parameter Store for database credentials and application secrets.
- CloudWatch log groups per service and environment.
- S3 for user/application object storage where required by the application.
- CloudFront in front of S3 if `Static` is later removed from ECS.

No database file should be stored on ECS instance storage. The deployment model uses PostgreSQL rather than the SQLite backup assumptions in the legacy scripts.

## 4) IAM and OIDC

The GitHub Actions role trust policy must restrict:

- The GitHub organization or owner.
- This repository.
- The deployment branch or tag condition.
- The GitHub environment where applicable.

The workflow role should have only the permissions required to authenticate to ECR, push images, register task definitions, run the migration task, update ECS services, and read deployment status. Long-lived AWS access keys must not be required as GitHub secrets.

## 5) Infrastructure ownership

Infrastructure code should define resource names, task roles, capacity providers, ALB target groups, log groups, secret references, and environment-specific values. Real account IDs, ARNs, passwords, and private hostnames must remain outside documentation and source control.

## 6) Naming convention

Use a stable naming scheme:

```text
feather-<environment>-<resource>
```

Examples include `feather-dev-cluster`, `feather-staging-webapp`, and `feather-production-worker`. Use `dev`, `staging`, and `production` consistently. Do not use `beta` as an AWS environment name; `beta` is a release-tag channel.

## 7) ECS task definitions

Each long-running workload should have an independent task-definition family specifying:

- Immutable image tag or digest.
- CPU and memory reservation.
- Container port, where applicable.
- `awslogs` configuration.
- ECS task execution role and workload task role.
- Secrets Manager or SSM references.
- Environment and release metadata.
- Linux user and read-only filesystem settings where compatible.
- Stop timeout and health-check behavior.

The Migrator task definition uses the target environment’s image provenance, secrets, subnets, and security groups but has a one-shot command and no load balancer registration.

## 8) IAM roles

| Role | Trusted principal | Main permissions |
| --- | --- | --- |
| GitHub deployment role | GitHub OIDC | ECR publish and ECS deployment operations |
| ECS task execution role | `ecs-tasks.amazonaws.com` | Pull ECR images and write logs |
| WebApp task role | `ecs-tasks.amazonaws.com` | Web runtime permissions |
| Worker task role | `ecs-tasks.amazonaws.com` | Job, storage, and mail permissions |
| Migrator task role | `ecs-tasks.amazonaws.com` | Database migration permissions |
| EC2 instance role | EC2 | ECS registration, ECR pulls, CloudWatch, and SSM |

The task execution role and task role should remain separate. The EC2 instance role must not contain application secrets.

## 9) Network flow

```text
Client -> ALB public subnets -> ECS tasks in private subnets
                                      |
                                      +-> RDS PostgreSQL
                                      +-> ECR, Logs, SSM, and required AWS APIs
```

Document the required security-group flow for every environment. RDS accepts traffic only from the ECS service security group. ECS instances must not expose public SSH; use SSM Session Manager.

## 10) Capacity planning

Capacity must cover the largest rolling deployment, including replacement tasks while old tasks remain healthy. Document instance type and architecture, Auto Scaling Group minimum/desired/maximum, task CPU and memory, maximum tasks per instance, Availability Zone distribution, scaling alarms, and instance-draining behavior.

The development environment may use smaller capacity, but it must preserve the same task-definition and deployment behavior as staging and production.
