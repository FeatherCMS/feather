# Legacy Deployment Migration

The sibling `deploy_scripts` directory documents the previous deployment system. It must be treated as a migration reference rather than as the ECS deployment implementation.

## 1) Legacy behavior

The legacy scripts:

- Build Swift binaries inside a builder container or remote environment.
- Clone repositories over SSH.
- Copy binaries to EC2 filesystem paths.
- Stop and start `systemd` services.
- Use EFS for build output in some ECS task definitions.
- Back up SQLite files and application binaries.
- Depend on long-lived AWS access-key secrets in GitHub workflows.
- Use account-specific ARNs, host aliases, and service names.

## 2) Target replacement

| Legacy behavior | ECS replacement |
| --- | --- |
| Remote SSH deployment | ECS service update and SSM for operations |
| Build on deployment host | Build in GitHub Actions |
| Binary copied to host | Immutable image stored in ECR |
| `systemd` restart | ECS rolling deployment |
| EFS build-output volume | ECR image layers and ECS task storage |
| SQLite backup | RDS backup and migration strategy |
| Long-lived AWS keys | GitHub OIDC role assumption |
| Remote script flags | Explicit workflow inputs and task definitions |

## 3) Retirement criteria

The legacy deployment path can be retired after:

- All required executables have ECS task definitions.
- Staging and production deployments use OIDC.
- Migration and rollback procedures have been exercised.
- CloudWatch logs and ALB health checks are operational.
- No deployment workflow requires SSH keys or long-lived AWS credentials.
- Existing EC2 services are no longer serving production traffic.

## 4) Migration phases

### Phase 1: Inventory

Record every legacy project, tag pattern, host group, service name, binary name, API directory, environment file, database, and deployment flag. The `deploy_scripts/aws` files are inventory inputs, not configuration to copy into the new workflow.

### Phase 2: Containerize

Build and publish the repository runtime images. Confirm that each image starts one executable, reads configuration from the environment, writes logs to standard output/error, and responds on its documented health route where applicable.

### Phase 3: Parallel staging

Deploy ECS services in development and staging while legacy services remain available. Compare health checks, logs, database behavior, worker processing, and externally visible API behavior.

### Phase 4: Production cutover

Move production traffic to the ALB-backed ECS services. Keep the legacy service available during the rollback window. Disable legacy deployment triggers before removing legacy runtime capacity.

### Phase 5: Retirement

Remove unused SSH keys, host aliases, EFS build-output paths, builder tasks, systemd units, and long-lived GitHub AWS credentials only after the retirement criteria are met.

## 5) Configuration translation

| Legacy value | New location |
| --- | --- |
| Service name | ECS service and task-definition family |
| Binary name | Container entrypoint/runtime image |
| Environment file | Secrets Manager/SSM references and non-secret task environment |
| `--need-migration` | Dedicated Migrator ECS task |
| SSH target | ECS cluster/service or SSM operational target |
| EFS output path | ECR image and ECS task storage where required |
| SQLite file | RDS PostgreSQL and an explicit data migration plan |
| Remote flags | Explicit workflow inputs and task definitions |

Destructive flags such as database deletion must not be carried into automated production workflows.

## 6) Legacy validation checklist

- Each supported tag routes to exactly one environment.
- The image digest is present in ECR.
- The Migrator task completes successfully.
- Required ECS services reach steady state.
- ALB health checks pass.
- Worker processing is observed.
- Logs and alarms are visible.
- Rollback to the previous ECS revision is documented.
- The new workflow does not require SSH keys or long-lived AWS credentials.
