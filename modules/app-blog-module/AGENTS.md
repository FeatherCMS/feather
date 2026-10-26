# Blog Module Guide

## Module boundaries

- The `BlogModule` SwiftPM target itself provides the module namespace. Do not
  add a redundant `BlogModule` enum. Keep module-level `Event` and
  `Permissions` declarations at the target root and entity namespaces under
  their own directories. Keep application-only namespaces, including `Public`,
  in `Sources/Layers/Application`.
- Keep models and repository contracts under
  `Sources/Layers/Domain/<Entity>`.
- Keep use-case contracts and implementations under
  `Sources/Layers/Application/<Entity>/<Operation>`; keep database adapters
  under `Sources/Layers/Infrastructure/<Entity>`.
- Keep backend API gateways and composition in `Composition/Backend`.
- Keep app-only code in `Composition/WebApp`, admin-only code in
  `Composition/WebAdmin`, and only genuinely shared client transport in
  `Composition/WebShared`. Do not make backend targets depend on web targets.
- Keep generated APIs in `Sources/APIs/<API>` and handwritten generators in
  `Sources/Generators/<API>`. Update generator sources, then regenerate; do not
  edit generated Swift or OpenAPI documents by hand.

## Blog behavior

- Blog owns posts, authors, author links, tags, and public route settings.
- Web metadata and Media asset/folder behavior remain owned by their modules;
  use their public abstractions rather than duplicating their tables.
- Preserve distinct `List` and structured `Search`/`Query` contracts and their
  separate schemas. Use simple lists for selectors and search for table views.
- Preserve the Admin API update-mask behavior for PATCH operations.
- Public routes expose published content only; admin routes enforce the Blog
  permission keys and use the authenticated request context for API clients.

## Persistence and verification

- Use Feather DBAL table, column, query, and migration abstractions. The Blog
  infrastructure target must not depend on a concrete database driver.
- Infrastructure tests use the shared mock connection and mock DBAL platform.
  Assert schema columns, timestamps, defaults, keys, indexes, and query mapping.
- Application tests exercise success, authorization denial, and operation
  semantics independently from HTTP tests.
- Composition tests exercise generated API routes and gateways with mock
  dependencies rather than a local PostgreSQL server.
- Keep route-specific views, forms, errors, and models under the owning entity
  and operation namespace. Avoid redundant `Blog` prefixes inside the Blog
  composition targets and keep view/detail naming consistent with the route
  operation (`View`).
- Never run builds, tests, or validation commands from this workspace; the
  repository-level instructions reserve validation for the developer. Use
  `make format` only when formatting is explicitly requested.

## OpenAPI and Docker

- Use `make openapi` to regenerate Admin/App YAML and clients. The script pins
  Mint's `swift-openapi-generator` to 1.14.2 by default.
- Keep shared generator code limited to schema declarations reused by the
  module's distinct Admin and App API generators; do not put generator
  assembly or I/O helpers in the shared target.
- Use the pinned `swaggerapi/swagger-ui:v5.32.15` image for both spec viewers;
  mount the versioned YAML directly and configure `SWAGGER_JSON`.
- Do not reintroduce a custom Swagger UI download, Nginx config, or a database
  service into the unit-test Compose workflow.
