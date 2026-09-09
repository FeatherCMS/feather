# ECS Deployment Architecture

This document is the source of truth for deploying the Feather application to Amazon ECS backed by Amazon EC2 capacity.

## 1) Target architecture

```text
GitHub push
    |
    v
GitHub Actions -- OIDC --> AWS
    |
    +--> Build release artifact
    +--> Build and push immutable images --> Amazon ECR
    |
    +--> Run Migrator ECS task
    +--> Update ECS service task definitions
                                      |
                                      v
                         ECS cluster + EC2 capacity provider
                                      |
                    +-----------------+------------------+
                    v                                    v
                 ALB                              Worker service
                    |
              WebApp / Server
                    |
                    v
             RDS PostgreSQL
```

ECS is the scheduler and deployment controller. EC2 instances provide the container capacity through an Auto Scaling Group and ECS capacity provider. The application processes do not deploy directly through SSH.

## 2) Executable mapping

| Executable | ECS mode | Purpose |
| --- | --- | --- |
| `WebApp` | ECS service behind ALB | Dynamic web application |
| `Server` | ECS service behind ALB when enabled | OpenAPI/API runtime |
| `Worker` | ECS service without ALB | Background jobs |
| `Migrator` | One-off ECS task | PostgreSQL migrations and seed data |
| `Static` | ECS service initially, or S3/CloudFront later | Static-file server |

The application package is built from `application/Package.swift`. The existing Docker build in `docker/application/Dockerfile` produces artifacts for all five executables. Runtime images are defined in `docker/application-runtime/Dockerfile`.

## 3) Release identity

Every release is identified by the Git commit SHA. ECR image tags must be immutable release identifiers such as:

```text
<account>.dkr.ecr.<region>.amazonaws.com/feather-webapp:<commit-sha>
<account>.dkr.ecr.<region>.amazonaws.com/feather-worker:<commit-sha>
```

Mutable tags such as `latest` may be used for local development only. ECS task definitions should reference the release image digest or SHA tag.

## 4) Deployment sequence

1. Build the application artifact image.
2. Publish runtime images to ECR under the commit SHA.
3. Render task definitions with the new image references.
4. Run the `Migrator` task and wait for successful completion.
5. Update `WebApp`, `Server`, `Worker`, and `Static` services that changed.
6. Wait for ECS deployment completion and ALB target health.
7. Request `/health` through the environment endpoint.
8. Retain the previous task-definition revision for rollback.

Migrations must be backward-compatible with the currently running application during rolling deployment. Destructive schema changes require a separate expand/migrate/contract release sequence.

## 5) Release tag routing

Release tags select the deployment environment. The workflow must validate the complete tag format before deploying.

| Tag format | Environment | Example |
| --- | --- | --- |
| `MAJOR.MINOR.PATCH-beta.N` | Development | `1.4.3-beta.1` |
| `MAJOR.MINOR.PATCH-rc.N` | Staging | `1.4.3-rc.1` |
| `MAJOR.MINOR.PATCH` | Production | `1.4.3` |

The routing rules are:

```text
*-beta.* -> dev
*-rc.*   -> staging
stable semantic version with no suffix -> production
anything else -> reject
```

Development tags use the `dev` deployment environment, not `beta`. The `beta` and `rc` portions identify the release channel; the AWS/GitHub environment names are `dev` and `staging`.

The parser must check prerelease tags before the stable-release pattern and must not infer production from an arbitrary tag. Tags such as `1.4.3-alpha.1`, `v1.4.3`, or `1.4.3-rc` are invalid unless explicitly supported by a later version of this contract.

## 6) Environments

Staging and production must use separate ECS clusters or clearly isolated services, databases, ECR repositories, secrets, and GitHub environments. Production deployment requires approval through the GitHub production environment.

The development environment should also use isolated ECS services, task roles, secrets, and database resources.

## 7) Ownership and boundaries

| Boundary | Responsibility |
| --- | --- |
| GitHub Actions | Select environment, build images, publish images, and request deployment |
| ECR | Store immutable application images |
| ECS | Schedule tasks, replace tasks, and perform service deployments |
| EC2 capacity provider | Supply and scale the instances on which ECS places tasks |

GitHub Actions must not configure application runtime values in source files. Runtime configuration is supplied through ECS task definitions and Secrets Manager or SSM references.

## 8) Image and task mapping

The existing `docker/application/Dockerfile` creates a common artifact set. Runtime targets in `docker/application-runtime/Dockerfile` should be published as separate images:

| ECR repository | Runtime target | Entrypoint |
| --- | --- | --- |
| `feather-webapp` | `web-app` | `WebApp` |
| `feather-server` | `server` | `Server` |
| `feather-worker` | `worker` | `Worker` |
| `feather-migrator` | `migrator` | `Migrator` |
| `feather-static` | `web-static` | `Static` |

Each image must contain one primary process. ECS production tasks must not run the builder image or clone the application repository at startup.

## 9) Service placement

Web-facing services require a desired count that permits rolling replacement. Production availability requirements normally require more than one task. `Worker` uses a separate service and is not registered in an ALB target group. `Migrator` is a one-shot task, never a long-running service.

`Static` may remain an ECS service during the initial deployment. Moving it to S3 and CloudFront is an independent optimization.

## 10) Deployment invariants

- A release image is immutable after publication.
- A deployment is identified by both Git tag and commit SHA.
- A failed migration prevents application rollout.
- A failed health check prevents deployment success.
- A previous task-definition revision remains available for rollback.
- Application rollback and database rollback are separate operations.
- No deployment depends on an interactive shell or a specific EC2 host.
