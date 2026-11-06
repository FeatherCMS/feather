# Feather Repository Guidance

## Scope and current sources

These rules apply throughout Feather. `Package.swift` defines target ownership and dependencies. Use active source in the owning target to follow current file and namespace patterns. The architecture docs describe intent, but some examples predate the `cms-*` package renames and current source layout; follow those examples only when they match the manifests and current code.

The workspace contains `application`, `openapi`, `native-app`, `feather-core`, and feature packages under `modules/cms-*-module`. The backend runtime has `Server`, `Migrator`, `Worker`, `WebApp`, and `WebStatic` targets. Module targets and products vary by package; do not assume every module owns every API or web surface.

## Architecture and package boundaries

- Keep dependencies directed inward: composition and infrastructure may depend on application and domain; application may depend on domain; domain must not depend on transport, database drivers, or web frameworks.
- Keep each declaration in the target that owns its responsibility. Use the package manifest as the authority for target boundaries.
- Within modules, follow the existing `Sources/Module`, `Sources/Layers/{Domain,Application,Infrastructure}`, `Sources/APIs`, `Sources/Generators`, and `Sources/Composition` layout where those directories are used.
- Do not add a namespace wrapper when the module target already supplies the namespace. Keep module-wide events and permissions at the module root and entity declarations under their entity namespace, following the owning package's current pattern.
- In `Package.swift`, prefer a target folder `path` with normal folder discovery. Do not enumerate individual source files or add `exclude` lists unless a concrete packaging need requires them.
- Add direct package products only when the target uses them and SwiftPM or the compiler requires the direct dependency. Remove dependencies made unused by a change.

## Domain, application, and persistence

- Keep domain models, business rules, and ports in Domain; use-case inputs, outputs, authorization, and orchestration in Application; database and external-service adapters in Infrastructure.
- Keep use-cases focused on one operation. Put only the dependencies an operation needs in its scope. A scope is a dependency bundle, not a place for behavior or database operations.
- Use repositories and queries for persistence behavior. Use Feather DBAL tables, rows, queries, and migrations for standard persistence.
- Keep custom SQL inside the owning Infrastructure `Database/AccessLayer`, and use it only when DBAL cannot express the behavior. Bind values; interpolate only trusted SQL fragments or allowlisted identifiers.
- Keep table, row, and migration definitions consistent. Ordinary package tests should use the shared mock database connection and platform, not require a live database or concrete driver.

## APIs and generated code

- Keep API contracts in the owning API target and handwritten generator sources in the package's generator target. Change generator sources and regenerate YAML and Swift outputs through that package's checked-in script or Make target when the requested change requires regenerated artifacts. Do not hand-edit generated files.
- Keep Admin and App APIs separate when a module owns both. Preserve operation IDs and public schema identifiers when reorganizing generators.
- Keep lightweight `List` operations distinct from structured, paginated `Search` behavior. Where the HTTP API names the structured operation `Query`, adapt it to the Application `Search` use-case. Keep their inputs and output schemas distinct.
- PATCH update masks must preserve the difference between omitted fields and explicitly cleared nullable fields. Keep documented statuses and error schemas aligned with gateway and middleware behavior.
- Backend gateways adapt generated operations to use-cases. Keep request and response mapping in the gateway operation that uses it; do not add standalone mapping files or shared mapping extensions for one-off mappings.

## Web composition

- Keep backend targets independent of WebApp and WebAdmin targets. Keep App and Admin clients, routes, middleware, and event handlers in their corresponding targets; put code in WebShared only when both surfaces genuinely use it.
- Pass `AppEnvironment` through the router hierarchy. Create authenticated API clients at the request boundary from the environment and `AuthenticatedRequestContext`; do not share request credentials globally.
- Put WebAdmin route features under `Sources/Composition/WebAdmin/Routes/<Entity>/<Operation>/` where that layout is used. Feature routers construct collaborators and register routes. Keep route types under the entity/operation namespace; do not add generic `Abstraction` or `Implementation` directory layers.
- Controllers own HTTP boundary concerns such as decoding, authorization, nonce handling, and error branching. Interactors coordinate operations, repositories adapt API responses, and presenters prepare display state. Views render prepared state and actions; they do not make API calls or decide authorization.
- Build components with `context.build(component)`. Do not call `.html(context:)` at component call sites. Call `context.register(...)` only when component HTML is omitted but its styles or scripts still need registration.

## Swift and change style

- Follow neighboring handwritten code for naming, namespaces, access control, and file placement. Keep one primary declaration or one tightly related namespace-extension family per file.
- Avoid handwritten `typealias` declarations and tuples; use named types unless an existing API or generated code requires otherwise. Generated code is exempt from handwritten layout rules.
- Do not introduce abstractions or helpers without a clear reuse or boundary need. Keep changes focused and do not modify unrelated files.
- Format function declarations with the name and `(` on the first line, one parameter per following line, no trailing comma, and the closing `)` plus effects and return type on the line with `{`.

## Ownership exceptions

- `cms-user-module` owns an Admin API, not an App API.
- `cms-system-module` treats `Job` as read-only; do not add mutation operations it does not own.
- `cms-redirect-module` keeps Admin rule management separate from App redirect resolution. If fallback lookup fails, preserve the application's original response and log the failure.
- Auth uses User-owned identity/role contracts and System-owned permission contracts. Account must not duplicate Auth/User-owned tables or access their private schemas. Blog uses Web and Media-owned contracts for their metadata and assets instead of duplicating that data.

## Tests and validation

- Keep tests aligned with the production layers and composition boundaries. Cover use-case behavior separately from HTTP composition; use shared DBAL mocks for ordinary infrastructure tests.
- Do not run builds, tests, formatting, or other validation commands in agent workflows. A checked-in generator may be run when needed to produce artifacts for the requested change. Record remaining checks for the developer.
