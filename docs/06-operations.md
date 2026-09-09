# ECS Operations Runbook

## 1) Basic checks

For an environment, inspect:

- ECS service deployment status.
- Running and stopped task reasons.
- ALB target health.
- CloudWatch logs for the affected service.
- RDS connectivity and database health.

The application health endpoint is `/health`. The ALB health check should use the correct service port and should not require user authentication.

## 2) Migration task

Run `Migrator` as an ECS one-off task using the same image SHA and environment configuration as the application release. Confirm a successful exit code before deploying application services. Do not run migrations independently on every application task.

## 3) Rollback

Rollback procedure:

1. Identify the last healthy task-definition revision and image SHA.
2. Update the affected ECS service to that revision.
3. Wait for ECS deployment completion.
4. Verify ALB target health and `/health`.
5. Record the failed release and rollback reason.

Database rollback is separate from application rollback. A migration must be designed so that returning to the previous application image remains safe during the deployment window.

## 4) Access

Use IAM and SSM Session Manager for operational access. Public SSH access and deployment through an SSH host alias are not part of the target architecture.

## 5) First-response procedure

1. Identify the environment and release tag.
2. Check the GitHub Actions result and derived environment output.
3. Check ECS service events and deployment history.
4. Check stopped-task exit codes and reasons.
5. Check ALB target health and recent CloudWatch logs.
6. Classify the issue as startup, image retrieval, configuration, networking, database, or capacity related.
7. Stop further rollout if the cause is unknown.
8. Roll back the affected service when the previous revision is known to be healthy.

Repeated task restarts without recording the failure reason can hide image, secret, migration, or capacity defects.

## 6) Common failure modes

| Symptom | Likely causes | First checks |
| --- | --- | --- |
| Tasks never start | Capacity, placement, image pull, execution role | ECS events, EC2 capacity, ECR permissions |
| Tasks stop immediately | Missing secret, invalid config, process crash | Stopped reason and container logs |
| ALB target unhealthy | Wrong port, bind address, route, security group | Port mapping, `/health`, target health |
| Migration fails | Database access, incompatible schema, missing secret | Migrator logs and RDS connectivity |
| Worker restarts | Job configuration, dependency outage, resource limit | Worker logs and task resources |
| Deployment stalls | Insufficient spare capacity or unhealthy tasks | ECS deployment and ASG capacity |
| Logs are absent | Role, log group, or network issue | Execution role and CloudWatch group |

## 7) Release and rollback records

Retain the release tag, commit SHA, environment, production approver, image digests, task-definition revisions, Migrator task ARN and exit status, deployment times, health result, and rollback details. This record should be available from GitHub Actions and AWS history without relying on local shell history.

## 8) Scaling and maintenance

Scale ECS services using request load, response behavior, queue depth, job latency, or another documented metric. Scale the Auto Scaling Group when ECS placement events show insufficient cluster capacity. During EC2 replacement, use ECS container-instance draining so tasks are rescheduled before termination. Update AMIs and ECS agents through the launch template and Auto Scaling Group process.
