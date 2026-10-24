# System Module Guide

Use this guide as the System module's source of truth for target boundaries,
namespaces, application operations, database adapters, OpenAPI generation,
WebAdmin composition, and tests.

## Module structure

- `SystemModule`, `SystemDomain`, `SystemApplication`,
  `SystemInfrastructure`, `SystemAdminAPI`, `SystemBackend`, and
  `SystemWebAdmin` are separate targets with the boundaries described in
  `Package.swift`.
- Domain entities are `Permission`, `Variable`, and `Job`. Keep their models,
  application operations, queries, tables, and persistence adapters under the
  corresponding entity namespace and directory.
- `Job` is read-only from this module's perspective. Do not add mutation
  operations or an API surface the module does not own.
- Keep frontend-only declarations in `SystemWebAdmin`; backend, application,
  and domain targets must not gain a WebAdmin namespace dependency.
- System owns the Admin API, its OpenAPI generator, the generated YAML and
  Swift API, and the WebAdmin client. Change handwritten generator sources,
  then regenerate through the checked-in script/Makefile; do not edit generated
  Swift or YAML by hand.

## Application and database

- Model application operations as sibling namespace declarations, for example
  `Variable.Add.Input|Output|Scope|UseCase`, `Variable.List.*`, and
  `Variable.Search.*`. `List` is for lightweight list results; `Search` backs
  structured query results. Keep their criteria and result DTOs separate.
- Query criteria belong to the input's named `Query` value. Keep database
  adapters under their owning query/repository namespace and use DBAL table,
  column, and schema definitions; do not introduce driver-specific SQL or
  driver dependencies into the module's ordinary infrastructure target.
- Keep aggregate migrations and seed migration/event registration at the
  infrastructure root. Each table's `Columns` declarations and creation schema
  must describe the same columns.
- Infrastructure tests use the shared mock connection and mock platform.
  Assert generated schema details—columns, timestamp fields, defaults, keys,
  and indexes—not only query counts or table names. Application tests cover
  use-case success/authorization and behavior independently of HTTP tests.

## Backend and API

- Backend gateways adapt generated Admin API operations to application
  use-cases; group factories under `UseCases/<Entity>/` and keep mapping helpers
  near the relevant entity/operation.
- HTTP `List` and `Query` are separate API operations with separately owned
  schemas. The application `Search` use-case serves structured `Query`
  requests; the simple `List` endpoint remains appropriate for lightweight
  lookups/autocomplete.
- PATCH endpoints use the required update-mask contract. Preserve the
  distinction between omitted fields, selected nullable fields being cleared,
  and invalid/missing selected values through gateway and application layers.
- Keep API error schemas and documented statuses aligned with actual gateway
  and middleware responses.

## WebAdmin

- Put routes under `Sources/Composition/WebAdmin/Routes/<Entity>/<Operation>/`.
  Extend the entity/operation namespace with `Controller`, `Interactor`,
  `Presenter`, `Repository`, and `Router` as needed. Keep interfaces and default
  implementations in matching files; do not create generic `Feature`,
  `Abstraction/`, or `Implementation/` wrappers.
- Feature routers construct their collaborators and register handlers. The
  entity/top-level router supplies route roots, `AppEnvironment`, and rendering
  configuration. Use `WebRoute` values for route templates and links.
- Create API clients at the authenticated request boundary from
  `AppEnvironment` plus `AuthenticatedRequestContext`; the environment provides
  API configuration and the request context provides request credentials.
- Controllers own HTTP boundary concerns, permission gates, input decoding,
  nonce validation, and error branching. Interactors coordinate operations;
  repositories map generated API types and documented responses; presenters
  prepare user-facing state and responses.
- Use existing `Admin` UI components. Views render prepared state and supplied
  actions; they do not make API calls or decide authorization. Hide actions the
  current user cannot perform and render permission/error states through the
  presenter.
- Form payload models contain feature fields only. Wrap them in
  `NonceRequest<Input>` at the controller boundary. Normalize optional empty
  strings consistently, preserve submitted values on validation errors, and
  associate errors with their fields.
- List and remove flows preserve search/pagination and origin context. Removal
  uses a nonce-protected confirmation POST and returns cancellation to the
  page from which removal began.

## Validation and documentation

- Do not mirror every Swift import with a direct package dependency. Rely on
  transitive module availability when SwiftPM/the compiler permits it; add a
  direct product dependency only when required to build. Remove unused direct
  dependencies after code moves, and use `public import` only for deliberate
  re-exports.
- Keep this guide aligned with the current source layout. Do not restore
  instructions for the old `Features/Admin`, `Abstraction/Implementation`, or
  frontend `buildRuntime` structure.
- Before handing off changes, run formatting, the System package tests/build,
  and generator validation when API sources changed. Check downstream callers
  when public namespaces or generated contracts changed.
