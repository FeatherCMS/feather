# Web Module Guide

Use this guide as the Web module's source of truth for ownership, target
boundaries, APIs, persistence, WebApp/WebAdmin composition, and tests. Keep
the behavior and public contracts specific to this module while following the
current System, User, and Redirect module structure.

## Ownership and targets

- `WebModule` owns Web permissions, events, and cross-module Web contracts.
- Keep domain models and repository interfaces in `WebDomain`; application
  operations in `WebApplication`; persistence adapters and migrations in
  `WebInfrastructure`; generated API types in `WebAdminAPI`/`WebAppAPI`; and
  HTTP gateways in `WebBackend`.
- Keep public-site routing and rendering in `WebModuleWebApp`, admin UI routes
  and event handlers in `WebModuleWebAdmin`, and implementation-neutral helpers
  used by both in the internal `WebModuleWebShared` target.
- Keep the dependency direction from the package manifest. Do not introduce
  WebAdmin dependencies into backend, domain, application, or WebApp targets.
- Do not add PostgreSQL-specific query or driver dependencies to ordinary
  infrastructure code. Use the shared Feather DBAL abstractions and mock
  connection/platform in tests.

## Names and file layout

- Nest domain declarations under their entity (`Menu.Model`,
  `Menu.Repository.Interface`, etc.). Nest application contracts under the
  entity and operation (`Page.Add.Action|Input|Output|Scope|UseCase`,
  `Page.Search.Input.Query`, and `Page.Search.Output`). Keep each declaration
  in its own appropriately named file and operation directory.
- Use distinct `List` and `Search` operations and their own schemas. Lightweight
  selectors use List; structured filtering, sorting, pagination, and table
  results use Search/HTTP Query.
- Put tables, schema definitions, repository/query adapters, and row types under
  their owning entity. Keep aggregate migration, seed migration, and event
  handler registration at the Infrastructure root. Use `Table+Migration.swift`
  and `Table+SeedMigration.swift` for aggregate migrations.
- In a namespace extension, refer to immediate nested declarations directly
  (`Database: Interface`, `Default: Interface`) instead of repeating their full
  qualification. Keep filenames, symbols, and namespace paths aligned.
- Keep generated API and generator code organized per API and entity. Generator
  sources are handwritten; generated Swift and YAML must be regenerated via
  the checked-in script/Makefile, never edited directly.

## Web composition

- Keep WebApp and WebAdmin clients separate. Build clients from
  `AppEnvironment` and, for authenticated admin requests,
  `AuthenticatedRequestContext` at the request boundary. Pass the environment
  through the router tree; do not pass a client builder, a bare extracted URL,
  or request credentials globally.
- Put admin route feature code under
  `Sources/Composition/WebAdmin/Routes/<Entity>/<Operation>/`. Extend the
  entity/operation namespace with `Controller`, `Interactor`, `Presenter`,
  `Repository`, and `Router` as required. Keep `Interface` and implementations
  together by namespace; do not add generic `Abstraction/` or
  `Implementation/` directory layers.
- Each entity router owns its route values and registers child routes. The
  top-level router supplies route roots, environment, and rendering
  configuration. Use `WebRoute` for route templates and link generation.
- Controllers handle HTTP boundary concerns; interactors coordinate;
  repositories adapt generated API clients; presenters prepare view state.
  Views render prepared state and actions rather than performing API calls or
  deciding authorization.
- WebApp-only middleware, route handlers, generated clients, templates, and
  rendering helpers belong in `WebModuleWebApp`. Admin event handlers and
  admin UI helpers belong in `WebModuleWebAdmin`. Shared target code must be
  neutral and must not depend on either surface.

## Tests and validation

- Keep tests under `Tests/Layers/{Domain,Application,Infrastructure}` and
  `Tests/Composition/{Backend,WebApp,WebAdmin}`. Application tests cover
  use-case behavior independently of HTTP tests.
- Infrastructure tests use DBAL mock connections/platforms. Assert table
  columns, timestamps, defaults, keys, indexes, and query mappings without
  depending on SQL text or a running database service.
- Backend composition tests exercise generated routers and gateways with mock
  persistence/authorization and assert HTTP status and response bodies.
- Do not mirror every import with a direct package dependency. Declare only
  dependencies SwiftPM/compiler diagnostics require, and remove unused direct
  products after moving code.
- Repository-level `AGENTS.md` forbids running tests or validations in agent
  workflows. Record formatting, package, generator, and downstream-consumer
  checks in the handoff notes when relevant, but do not execute them here.
