# Account Module Guide

Use this guide as the Account module's source of truth for target boundaries,
namespaces, application operations, database adapters, OpenAPI generation,
WebAdmin/WebApp composition, and tests.

## Module structure

- `AccountModule`, `AccountDomain`, `AccountApplication`,
  `AccountInfrastructure`, `AccountAdminAPI`, `AccountAppAPI`,
  `AccountBackend`, `AccountWebAdmin`, and `AccountWebApp` are separate Swift
  targets. Keep declarations in the target that owns their responsibility.
- `AccountModule` is the Swift target namespace, not a declared enum. Keep
  module-level `Event` and `Permissions` beside the entity namespaces, matching
  the User and System modules.
- Account creation is exposed through the `Account.Add` use-case namespace.
  The other Account entities are `Profile`, `Invitation`, and `Settings`; keep
  their models, contracts, operations, permissions, table definitions, and
  adapters grouped by entity. Module-wide event registration extends
  `AccountModule.Event` in infrastructure.
- Group entity namespaces and their permission declarations under
  `Sources/Module/<Entity>/`; keep only module-wide `Event` and `Permissions`
  at the `Module` root. Keep the seed event contract under
  `Layers/Application/Event/Seed/`.
- `AccountWebAdmin` owns admin routes, events, and the Admin API client.
  `AccountWebApp` owns public/app routes and its App API client. Do not make the
  backend depend on either web target, or make WebApp depend on WebAdmin.
- Account owns separate Admin and App APIs and generators. Change generator
  sources and regenerate; never edit generated Swift or OpenAPI output by hand.

## Application and persistence

- Model operations under entity namespaces and keep action, input, output,
  authorization scope, query/repository contracts, and use-case implementation
  in focused operation-specific files.
- Keep backend use-case wiring under `Composition/Backend/UseCases/<Entity>/`
  and group operation-specific adapters under their owning entity.
- Use DBAL table, column, and migration schemas. Tables are nested below their
  owning entity (`Profile.Table`, `Invitation.Table`, `Settings.Table`).
  Keep aggregate/seed migration registration at the infrastructure root.
- Keep authorization and persistence for Auth/User-owned data in those modules;
  Account may compose their public contracts but must not duplicate their
  tables or reach into their private schema.
- Infrastructure tests use the shared mock database connection and platform.
  Assert columns, timestamps, defaults, constraints, and indexes. Application
  tests independently cover success, authorization denial, and operation
  semantics.

## Backend and API

- Backend gateways adapt generated API operations to application use-cases.
  Keep entity-specific factories and mappings grouped by entity/operation.
- Keep App and Admin API schemas and generators separate. Shared schemas are
  duplicated at the API boundary unless another module genuinely consumes a
  dedicated generator-support product.
- Invitation `List` is for lightweight selection/autocomplete; invitation
  `Search` is for structured table queries. Keep their schemas and result
  contracts separate.
- PATCH uses the update-mask contract and must distinguish omitted values from
  explicit clears. Documented response statuses and error schemas must match
  gateway and middleware behavior.

## Web composition

- Put routes in `Sources/Composition/WebAdmin/Routes/<Entity>/<Operation>/`
  and `Sources/Composition/WebApp/Routes/<Entity>/<Operation>/`. Use the
  entity/operation namespace for Router, Controller, Interactor, Presenter,
  and Repository abstractions and implementations; avoid flat `Admin...`
  symbols and `Abstraction/Implementation` wrappers.
- Route routers construct collaborators and register routes. Pass the shared
  app environment at composition boundaries and create authenticated API
  clients from that environment plus the request context.
- Keep views focused on rendering prepared state. Controllers own request,
  authorization, nonce, and error-boundary concerns; presenters prepare
  display state; repositories map generated API models.
- Keep App and Admin composition independent. Shared helpers belong in a
  WebShared target only when both surfaces genuinely use them.

## Validation

- Do not mirror every Swift import as a direct package dependency. Add direct
  products only when the compiler or SwiftPM requires them; remove unused direct
  dependencies after changes.
- Keep test targets under `Tests/Layers` and `Tests/Composition`, matching the
  layer they exercise. HTTP tests should use the real generated router/gateway
  with mock database and authorization dependencies.
- Before handoff, run Swift formatting, package build/tests, generator
  validation, and Docker test configuration when those surfaces changed.
