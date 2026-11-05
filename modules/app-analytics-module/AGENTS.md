# Analytics Module Guide

## Module structure and ownership

- Keep `AnalyticsModule`, `AnalyticsDomain`, `AnalyticsApplication`,
  `AnalyticsInfrastructure`, `AnalyticsAdminAPI`, `AnalyticsAppAPI`,
  `AnalyticsBackend`, `AnalyticsWebShared`, `AnalyticsWebApp`, and
  `AnalyticsWebAdmin` in their existing separate targets.
- Keep analytics entities such as `Log`, `Insight`, and `NotFound` under their
  own namespaces. Put domain models and contracts in Domain, operation
  contracts/use-cases in Application, and DBAL persistence in Infrastructure.
- Analytics owns its Admin and App APIs. Keep event tracking in the App API and
  log queries/overview in the Admin API; preserve existing operation and schema
  identifiers when changing generator source.
- Keep web-specific declarations in the matching Web target. The App target
  owns tracking middleware and its client; the Admin target owns dashboard
  routes, event providers, and its client.

## Application and persistence

- Keep `Log.Track`, `Log.Search`, `Log.Detail`, and `Log.Overview` as separate
  Application operations with operation-owned inputs, outputs, actions,
  scopes, and query contracts as applicable. Do not add an Application
  `Log.List` use-case unless a distinct lightweight log-picker use-case is
  introduced.
- The WebAdmin `Log.List` screen is a presentation feature and uses its
  `Repository` abstraction to call the structured Admin API `Query` operation,
  backed by `Log.Search` in Application. Keep `Repository` naming in web
  composition; `Query` names the Application data-access contract and HTTP API
  operation. If a lightweight picker is later needed, give it a separate
  `Log.List` Application use-case and API `List` contract with distinct
  criteria and schemas.
- Use FeatherDBAL table/row abstractions and schema migrations for standard
  CRUD and schema work. Keep any irreducible custom SQL inside the owning
  Infrastructure `Database/AccessLayer`.
- Use mock DBAL infrastructure tests. Test application tracking, query
  criteria, authorization, and event behavior independently of HTTP tests.

## Backend and web composition

- `AnalyticsBackend` owns Admin/App gateways and use-case construction. Keep
  transport mapping in the gateway operation that uses it; do not add standalone
  mapping files.
- Keep App middleware and clients in `AnalyticsWebApp`; keep Admin dashboard
  routes/events/clients in `AnalyticsWebAdmin`; place only surface-neutral
  transport helpers in `AnalyticsWebShared`.
- Web route features use the entity/operation namespace with
  `Controller`, `Interactor`, `Presenter`, `Repository`, and `Router` as
  needed. Feature routers construct collaborators and register routes using
  `WebRoute`; pass `AppEnvironment` through the router tree.
- Build authenticated Admin API clients at the request boundary from
  `AppEnvironment` and `AuthenticatedRequestContext`. Repositories adapt
  generated API responses to route data; presenters prepare display state.

## API generation and validation

- Change handwritten sources under `Sources/Generators/Admin` or `App`, then
  regenerate the corresponding YAML and Swift API outputs with the checked-in
  generator workflow. Do not edit generated files directly.
- Keep one entity namespace and entity `PathCollection` per resource, with
  operation-specific paths/schemas and an API-level collection that merges
  them. Set explicit operation IDs and preserve public component identifiers.
- Do not mirror every import as a package dependency. Add direct products only
  when the compiler/SwiftPM requires them; remove unused dependencies.
- The repository-level `AGENTS.md` prohibits running builds, tests, and other
  validations in agent workflows. Record needed verification in the handoff;
  do not execute it here.
