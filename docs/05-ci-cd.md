# CI/CD Workflow

## 1) Pull requests

Pull requests should compile the application package and run the relevant test suites. Pull-request jobs must not deploy or receive production credentials.

## 2) Tag-to-environment routing

Release workflows run on tags and map tags to deployment environments as follows:

| Tag | GitHub environment | Deployment target |
| --- | --- | --- |
| `1.4.3-beta.1` | `dev` | Development ECS services |
| `1.4.3-rc.1` | `staging` | Staging ECS services |
| `1.4.3` | `production` | Production ECS services |

The intended matching expressions are:

```text
^[0-9]+\.[0-9]+\.[0-9]+-beta\.[0-9]+$  -> dev
^[0-9]+\.[0-9]+\.[0-9]+-rc\.[0-9]+$    -> staging
^[0-9]+\.[0-9]+\.[0-9]+$                -> production
```

The workflow must fail for tags that match none of these expressions. It must not deploy an unknown tag to production by default. The production environment must require manual approval.

## 3) Development

Pushing a tag such as `1.4.3-beta.1` selects the `dev` GitHub environment, publishes commit-SHA images to development ECR repositories, runs the development `Migrator` task, and deploys development ECS services.

## 4) Staging

Pushing a tag such as `1.4.3-rc.1` selects the `staging` GitHub environment, publishes commit-SHA images to staging ECR repositories, runs the staging `Migrator` task, and deploys staging ECS services.

## 5) Production

Pushing a tag such as `1.4.3` selects the protected `production` GitHub environment. The environment must require manual approval before AWS credentials are issued to the deployment job.

The production sequence is the same as staging, with production-specific ECS services, ECR repositories, task roles, secrets, and health-check URLs.

## 6) Workflow permissions

Deployment jobs require only the permissions needed for OIDC and repository checkout, typically:

```yaml
permissions:
  contents: read
  id-token: write
```

The AWS role is responsible for ECR and ECS authorization. AWS keys must not be stored in repository or environment secrets.

## 7) Failure handling

- If image build or push fails, no deployment occurs.
- If the migration task fails, service deployment stops.
- If ECS deployment fails health checks, the workflow fails and the previous task-definition revision remains available.
- Rollback updates the affected service to the previous known-good task-definition revision.

## 8) Workflow event contract

Deployment runs on release tags. The job-level parser is authoritative even if the workflow trigger uses broad patterns:

```yaml
on:
  push:
    tags:
      - '*.*.*'
      - '*.*.*-beta.*'
      - '*.*.*-rc.*'
```

The parser must reject unsupported tags. Pull requests and ordinary branch pushes must not deploy.

Derived values should be calculated once and passed to later jobs:

| Value | Example |
| --- | --- |
| `release_tag` | `1.4.3-rc.1` |
| `commit_sha` | `abc123...` |
| `environment` | `staging` |
| `cluster` | `feather-staging-cluster` |
| `image_tag` | `abc123...` |

Individual jobs must not independently reinterpret the tag.

## 9) Recommended job graph

```text
parse-release -> build-images-and-push -> render-task-definitions
                                      -> run-migrator
                                      -> deploy-services
                                      -> verify-health
```

The actual dependencies must enforce this order: migration after image publication, service deployment after successful migration, and verification after every required service deployment.

## 10) Image build requirements

The build job checks out the exact tagged commit, uses the repository root as Docker context, builds the common artifact stage once where possible, and publishes one runtime image per executable. It records image digests and uses the committed package resolution state. It must not run `swift package update`, compile on a deployment host, clone source inside a production task, or require SSH keys.

## 11) Migration task requirements

The migration job runs exactly one `Migrator` task with the target environment’s cluster, subnets, security groups, task role, and secrets. It waits for completion, checks the exit code and stopped reason, and stops the workflow on failure or timeout. Retries require assessment of the migration’s partial state.

## 12) Deployment verification

Verification must confirm that ECS reached steady state, desired and running task counts match, no essential container exited, ALB targets are healthy, `/health` returns success, startup logs are present, and the running image digest matches the workflow output.
