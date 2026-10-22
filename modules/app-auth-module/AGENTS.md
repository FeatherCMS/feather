# Auth Module Guide

Keep this package aligned with the current System, User, and Redirect module
structure. Preserve Auth-specific behavior and API ownership; do not carry
forward legacy layouts merely because they still compile.

## Targets and ownership

- Keep the module namespace, Domain, Application, Infrastructure, each owned
  generated API, Backend, and web surfaces in separate targets/products.
- Auth's web targets are `AuthWebShared`, `AuthWebApp`, and `AuthWebAdmin`,
  backed by `Composition/WebShared`, `WebApp`, and `WebAdmin`. Shared code must
  be surface-neutral; app and admin request contexts and API clients stay in
  their respective targets. `AuthWebApp` must not depend on `FeatherWebAdmin`;
  render App pages through the injectable `FeatherWebApp.TemplateRenderer`
  contract and keep Auth Mustache templates in the App target's resources.
- Keep the dependency direction `AuthModule <- AuthDomain <- AuthApplication
  <- AuthInfrastructure`, with Backend and the web targets depending only on
  the layers they compose. Do not add imports as direct dependencies unless
  SwiftPM/compiler diagnostics require them.
- Auth owns authentication credentials, email addresses, magic links,
  sessions, and role-permission associations. Identity and Role models,
  repositories, and authorization queries remain owned by User. Permission
  models and tables remain owned by System.

## Namespaces and layers

- Put public Auth namespaces in `Sources/Module`. Use top-level entity
  namespaces such as `Credential`, `Email`, `MagicLink`, and `Session`; define
  their models as `<Entity>.Model` and repository contracts as
  `<Entity>.Repository.Interface`, and
  `<Entity>.Repository.Database` rather than parallel flat model/repository
  names. Keep entity files under `Layers/Domain/<Entity>/` and
  `Layers/Infrastructure/<Entity>/`.
- Put application operations under their entity and operation, with sibling
  `Action`, `Input`, `Output`, `Scope`, and `UseCase` declarations as needed.
  Use operation-specific scopes; share a scope only when multiple operations
  genuinely use the same dependency set. Keep query contracts distinct from
  list operations and name them for their actual behavior.
- Put module-wide events under `AuthModule.Event`; register infrastructure
  handlers as `AuthModule.Event.Handlers`. Aggregate Auth permissions through
  `AuthModule.Permissions`, while keeping permission keys grouped by entity.
- Keep persistence in DBAL table, query, and repository adapters. Put each
  entity's table, row definitions, queries, and repository in that entity's
  infrastructure directory. Keep aggregate table/seed migrations at the
  infrastructure root.

## APIs and web composition

- Generate only APIs Auth owns. Keep Admin and App OpenAPI generation separate
  where both contracts are owned, with entity/operation path items and API-level
  path collections matching the System generator. Do not hand-edit generated
  Swift or YAML; regenerate both and keep schemas, gateways, and clients aligned.
- Put backend gateways and use-case construction in `Composition/Backend`.
  Keep app middleware and app API clients in `WebApp`; admin routing, admin
  events, and admin API clients in `WebAdmin`; genuinely shared transport
  helpers belong in `WebShared`.
- Place WebAdmin route files directly under
  `Routes/<Entity>/<Operation>/`. Extend the owning entity/operation namespace
  with `Controller.Interface|Default`, `Interactor.Interface|Default`,
  `Presenter.Interface|Default`, `Repository.Interface|OpenAPI`, and `Router`
  as applicable. Do not introduce `Abstraction`, `Implementation`, `Models`,
  or `Views` wrapper directories, flat `Admin...` feature types, or typealiases.
- Pass `AppEnvironment` through the router tree and construct authenticated API
  clients at the request boundary from the environment and request context.

## Tests and validation

- Mirror production layers under `Tests/Layers` and composition under
  `Tests/Composition`. Keep domain and application behavior tests independent
  of a live database.
- Infrastructure tests should use Feather's mock database/DBAL connection and
  platform; verify schema columns, defaults, keys, indexes, and row/query
  mappings. Do not require PostgreSQL or another concrete driver for ordinary
  package tests. Keep any true database integration test in a separately
  identified integration suite.
- Test application authorization, success and error paths, transaction/event
  behavior, and query criteria. Test HTTP composition through generated routers
  and gateways using mocked persistence, checking status and response bodies.
- Before handoff, run Swift formatting, `swift build`, and `swift test` for this
  package. After public API changes, build downstream application consumers and
  validate every owned generator.
