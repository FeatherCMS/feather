# Redirect Module Guide

## Module structure and ownership

- Keep `RedirectModule`, `RedirectDomain`, `RedirectApplication`,
  `RedirectInfrastructure`, `RedirectBackend`, `RedirectAdminAPI`,
  `RedirectAppAPI`, `RedirectAdminOpenAPIGenerator`,
  `RedirectAppOpenAPIGenerator`, `RedirectWebAdmin`, and `RedirectWebApp` in
  their separate package targets.
- Use `RedirectModule.Rule` as the domain namespace. Keep rule models,
  application operations, queries, tables, and persistence adapters grouped
  under their owning entity/operation namespaces.
- Preserve the existing permission key strings when reorganizing their
  declarations.
- Redirect rules are resolved by the app-facing API. Keep the Admin API for
  rule management and the App API for public redirect resolution; do not merge
  their generators, generated API targets, or contracts.

## Application and persistence

- Keep `Rule.Add`, `Rule.Edit`, `Rule.Detail`, `Rule.List`, `Rule.Resolve`,
  `Rule.Search`, and `Rule.Remove` as distinct application operations with
  their relevant action, input, output, scope, use-case, and query contracts.
- `List` is for lightweight lookup results; `Search` handles structured
  criteria and paginated table results. Keep their schemas and result models
  distinct.
- Persist redirect rules through `RedirectModule.Rule.Table` and Feather DBAL.
  Keep table columns, row models, indexes, and migrations consistent.
- Ordinary tests use the shared mock database/platform and must not require
  PostgreSQL, certificates, or persistent volumes. Cover application behavior
  independently from HTTP composition.

## Backend and API

- `RedirectBackend` owns server-side Admin and App API gateways and adapts
  generated operations to application use-cases. It must not depend on
  `RedirectWebApp` or its middleware/client implementation.
- The Admin API owns rule-management `List` and `Query` operations with
  distinct schemas. WebAdmin tables use query/search; lightweight lookup
  controls may use list.
- The App API owns public redirect resolution. Keep its generated API client in
  `RedirectWebApp`, where the redirect middleware consumes it.
- Keep documented error schemas and statuses aligned with gateway and
  middleware responses.

## WebAdmin and WebApp

- Keep admin routes under
  `Sources/Composition/WebAdmin/Routes/Rule/<Operation>/`. Route components
  follow the System module's controller/interactor/presenter/repository/router
  structure and receive `AppEnvironment` through the router hierarchy.
- Construct Admin API clients at the authenticated request boundary from the
  environment and `AuthenticatedRequestContext`; do not pass only a URL
  through every feature or share request credentials globally.
- Keep the App API client, redirect middleware, and `RedirectRuleResolver` in
  `RedirectWebApp`. The resolver owns both lookup eligibility and async rule
  resolution. `DefaultRedirectRuleResolver` handles 404 GET/HEAD requests and
  excludes admin/auth paths and static assets; consuming apps may supply their
  own resolver and policy.
- Install redirect middleware after ordinary route handling so an existing
  application response takes precedence. If redirect lookup fails, preserve
  the original response and log the failure.

## OpenAPI, package, and validation

- Generate OpenAPI YAML and Swift API sources using
  `scripts/generate-openapi.sh`; do not edit generated YAML or API Swift files
  directly. Serve the generated OAS 3.2 documents with the pinned
  `swaggerapi/swagger-ui` Compose services.
- Do not mirror every Swift import with a direct package dependency. Rely on
  transitive module availability when SwiftPM/the compiler permits it; add a
  direct product dependency only when required to build. Remove unused direct
  dependencies after code moves, and use `public import` only for deliberate
  re-exports.
- Before handoff, run formatting, package build, `swift test --parallel`, and
  generator validation when the corresponding sources changed. Build/test
  downstream consumers after public namespace or API changes.
