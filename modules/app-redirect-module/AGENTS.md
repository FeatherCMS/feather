# Redirect module guide

Follow [`../../docs/module-conventions.md`](../../docs/module-conventions.md)
for target boundaries, namespace ownership, operation layout, DBAL usage,
OpenAPI generation, WebAdmin routing, tests, and Docker services. This guide
records Redirect-specific ownership only.

The module owns both `RedirectAdminAPI` and `RedirectAppAPI`. Keep their
generator targets and generated API targets separate. The admin API owns the
rule-management list and query operations; keep their schemas distinct. The
app API owns public redirect resolution. Do not add a separate API client or
builder target: admin clients are constructed from `AppEnvironment` and the
authenticated request context; the app client and redirect middleware belong
to backend composition.

Use `RedirectModule.Rule` as the domain namespace. Preserve the existing
permission key strings when reorganizing their declarations. Persist redirect
rules through `RedirectModule.Rule.Table` and Feather DBAL; ordinary module
tests use the shared mock database/platform and must not require PostgreSQL,
certificates, or persistent volumes.

Generate OpenAPI YAML and Swift API sources using
`scripts/generate-openapi.sh`; do not edit generated YAML or API Swift files
directly. Serve the generated OAS 3.2 files with the pinned
`swaggerapi/swagger-ui` Compose services.
