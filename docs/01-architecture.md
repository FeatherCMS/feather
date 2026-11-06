# Feather architecture overview

Feather CMS is a Swift modular monolith. The application runs several executables and composes feature packages that own their domain behavior, persistence, APIs, and web integrations.

## Repository layout

| Path | Responsibility |
| --- | --- |
| `application/` | Runtime executables: Server, Migrator, Worker, WebApp, and WebStatic. |
| `modules/cms-*-module/` | Feature packages, each with the targets and API surfaces it owns. |
| `feather-core/` | Shared contracts and reusable infrastructure used by the application and modules. |
| `docs/` | Architecture, conventions, and operational guides. |

The package manifest is the source of truth for a package's products, targets, and dependencies. A module does not necessarily own both Admin and App APIs or both web surfaces.

## Module layers

Feature packages separate business rules from technical adapters:

```text
Domain <- Application <- Infrastructure
                         ^
                         |
                  Backend composition
```

Application defines use cases and the ports they need. Infrastructure implements persistence and external-service adapters. Backend composition wires those implementations to use cases and generated HTTP handlers. Inner layers do not depend on HTTP, database drivers, or web frameworks.

## Request flow

A typical Admin API request follows this path:

```text
HTTP request
  -> generated API router
  -> module backend gateway
  -> Application use case
  -> Domain rules and ports
  -> Infrastructure adapter
  -> database or external service
```

The gateway maps generated request and response types at the transport boundary. Domain and Application code do not depend on generated API types.

## Runtime composition

`application/Sources/Server/Modules/` creates shared runtime dependencies and module use-case builders. `application/Sources/Server/Modules/Routes+Build.swift` installs middleware and registers the API gateways. Each executable owns its configuration model and loader under its own `Config/` directory.

See the [module guide](02-modules.md), [server guide](03-server.md), and [module conventions](08-module-conventions.md) for implementation details.
