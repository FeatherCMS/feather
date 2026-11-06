# Module guide

Use this guide to place a feature change in the correct target. The package's `Package.swift` defines its actual products and target boundaries; not every module has the same APIs or web surfaces.

## Common source layout

Where used, module source follows this layout:

```text
Sources/
  Module/                         # Public module and entity namespaces
  Layers/
    Domain/<Entity>/              # Models and domain ports
    Application/<Entity>/<Op>/    # Use cases, inputs, outputs, scopes, queries
    Infrastructure/<Entity>/      # Tables and adapter implementations
  APIs/<API>/                     # Generated API Swift; do not edit by hand
  Generators/<API>/               # Handwritten API generators
  Composition/
    Backend/                      # Gateways and use-case construction
    WebShared/                    # Code shared by both web surfaces
    WebApp/                       # App routes, clients, and middleware
    WebAdmin/                     # Admin routes, clients, and event handlers
```

Some packages omit surfaces they do not own. Follow the nearest current implementation rather than adding empty targets to match this diagram.

## Layer responsibilities

- **Domain** owns business models, invariants, domain errors, and ports. It must not import transport, database, or web-framework types.
- **Application** owns use cases, operation inputs and outputs, authorization, and orchestration. Scopes bundle dependencies; they do not contain behavior.
- **Infrastructure** owns DBAL tables, rows, migrations, and implementations of repository/query ports. Use DBAL for standard persistence. Keep custom SQL in `Database/AccessLayer` only when DBAL cannot express the query.
- **Backend composition** adapts generated API operations to use cases and assembles their dependencies.
- **Web composition** owns browser-facing routes, API clients, events, and rendering for the surface it serves.

Dependencies point toward the domain: Application depends on Domain; Infrastructure and Backend composition depend on the inner contracts they implement or assemble.

## Operations and namespaces

Group each operation under its entity, such as `Identity.Search` or `Rule.Add`. Keep operation-owned `Input`, `Output`, `Scope`, `Action`, and `UseCase` declarations in the Application target. Keep operation-specific queries and adapters close to that operation and entity.

Use `List` for lightweight selection results. Use the Application `Search` use case for structured criteria, sorting, pagination, and totals; an HTTP API commonly exposes that operation as `Query`. Keep the contracts distinct when both are needed.

## APIs and generated code

A module owns only the API surfaces declared in its manifest. Change handwritten generator sources and regenerate through the module's checked-in script or Make target. Do not hand-edit generated YAML or Swift. Keep API types at the boundary and map them in the gateway operation that uses them.

## Persistence and tests

Use Feather DBAL abstractions and keep schema columns, rows, and migrations consistent. Ordinary infrastructure tests should use the shared mock database connection and platform. Test use-case behavior separately from HTTP composition; composition tests should exercise the generated router and gateway with mock dependencies.

For detailed namespace, package, and route rules, see [module conventions](08-module-conventions.md).
