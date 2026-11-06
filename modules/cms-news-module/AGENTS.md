# News Module Guide

## Module structure and ownership

- Keep `NewsModule`, `NewsDomain`, `NewsApplication`, `NewsInfrastructure`,
  `NewsAdminAPI`, `NewsAppAPI`, `NewsBackend`, `NewsWebShared`,
  `NewsWebAdmin`, and `NewsWebApp` in their existing separate targets.
- Keep `Article`, `Category`, and `ArticleCategory` under their own namespaces.
  Domain owns models/contracts, Application owns operation use-cases and
  queries, and Infrastructure owns DBAL tables, migrations, and adapters.
- News owns Admin and App APIs. Admin article/category metadata schemas are
  transport contracts; shared metadata form behavior belongs to WebModule.
  Keep generated API schema mapping inside the relevant `Repository.OpenAPI`
  adapter rather than exposing generated schemas to route forms or presenters.
- Keep public content handlers and App routes in `NewsWebApp`; keep admin
  routes and Admin clients in `NewsWebAdmin`.

## Application and persistence

- Keep `List`, `Search`, and `Detail` operations separate for Article and
  Category. `List` is for lightweight selectors; `Search` is for paginated
  WebAdmin tables and structured query endpoints. Keep request criteria and
  response schemas separate between these operations.
- Keep public detail/list/search use-cases distinct from admin operations and
  depend only on the queries each use-case needs. Keep Article/Category
  associations under `ArticleCategory` rather than embedding association
  persistence in unrelated entity tables.
- Use FeatherDBAL table/row definitions and schema migrations for standard
  CRUD, constraints, and indexes. Keep custom SQL in the owning Infrastructure
  `Database/AccessLayer` only when DBAL cannot express the behavior.
- Infrastructure tests use mock DBAL/database components and verify resulting
  schema details. Application tests cover query behavior, authorization,
  transactions, and event publication independently of HTTP tests.

## Backend and web composition

- `NewsBackend` owns Admin/App gateways and use-case construction. Keep each
  request/response mapping beside the gateway operation using it; do not add
  standalone mappings files.
- Keep App API clients, public content handlers, and routes in `NewsWebApp`;
  Admin routes/events/clients in `NewsWebAdmin`; cross-surface helpers only in
  `NewsWebShared`.
- WebAdmin features use the entity/operation namespaces with
  `Controller`, `Interactor`, `Presenter`, `Repository`, and `Router` as
  needed. Routers own route registration and use `WebRoute`; pass
  `AppEnvironment` through the router hierarchy.
- Keep WebApp/WebAdmin adapters named `Repository`. Map generated API schemas
  to local route models at that boundary. Tables use the structured query
  endpoint; relationship/autocomplete selectors use the simple List endpoint.

## API generation and validation

- Change only handwritten sources under `Sources/Generators/Admin` or `App`,
  then regenerate YAML and Swift APIs through the checked-in workflow. Keep
  entity/operation namespaces, per-entity PathCollections, and API-level
  collection merging aligned with System. Preserve public component IDs and
  provide explicit operation IDs.
- Do not add every imported module as a direct package dependency. Add a direct
  product only when required by the compiler/SwiftPM and remove unused entries.
- The repository-level `AGENTS.md` prohibits running builds, tests, and other
  validations in agent workflows. Record needed verification in handoff notes;
  do not execute it here.
