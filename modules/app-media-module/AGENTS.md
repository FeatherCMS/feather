# Media Module Contributor Notes

- Keep public media models and repository contracts in `MediaDomain`; module
  namespaces, permissions, and module-wide event declarations belong in
  `MediaModule`.
- Keep use-case inputs, outputs, actions, scopes, and query contracts in
  `MediaApplication`. Database, storage, migration, and job implementations
  belong in `MediaInfrastructure`.
- Keep generated API sources under `Sources/APIs`. Update them only by running
  `scripts/generate-openapi.sh` or the corresponding Make target; do not patch
  generated Swift manually.
- Backend gateways adapt generated API operations to application use cases.
  Admin routes, page composition, and the admin API client belong in
  `MediaWebAdmin`.
- Construct `API.Client` from `AppEnvironment` and the authenticated request
  context in the feature router, then pass it to that feature's repository.
  Do not cache request credentials or pass a builder through route features.
- Route registration belongs to feature routers. Controllers implement request
  behavior; they do not register routes.
- Do not add a database-server dependency to ordinary unit tests. Keep package
  tests self-contained and use shared mock database facilities for new
  infrastructure or composition tests.
- The ordinary Docker test service must not depend on PostgreSQL, certificates,
  or persistent volumes. Use the pinned Swagger UI image for local OpenAPI
  viewing; do not add a custom UI download or Nginx image.
- After changing a public namespace or package product, search the Feather
  workspace for consumers and update them in the same change. The repository-
  level `AGENTS.md` forbids running builds or tests in agent workflows; record
  the needed checks for the developer without executing them here.
