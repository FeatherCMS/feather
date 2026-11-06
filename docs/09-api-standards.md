# API standards

This guide describes the current pattern used by Feather's generated Admin APIs. A module's generator and OpenAPI contract remain authoritative when an API has a documented exception.

## Collection and detail routes

A typical collection uses separate lightweight list and structured query operations:

| Purpose | Typical route | Application operation |
| --- | --- | --- |
| Lightweight selection results | `GET /api/v1/admin/{module}/{resources}` | `List` |
| Structured filtering, sorting, pagination, and totals | `POST /api/v1/admin/{module}/{resources}/query` | `Search` |
| Create one resource | `POST /api/v1/admin/{module}/{resources}` | `Add` |
| Read one resource | `GET /api/v1/admin/{module}/{resources}/{id}` | `Detail` |

The exact operations vary by resource. Do not add bulk, relation, or resolve routes unless the owning module needs and defines them.

For example, the System permissions API exposes `GET /api/v1/admin/system/permissions` for a lightweight list and `POST /api/v1/admin/system/permissions/query` for a structured search. The User and Redirect modules use the same separation for their owned resources.

## List and query behavior

- `List` returns a compact result suitable for selectors and autocomplete. Its criteria are usually query parameters and its result schema is distinct from the table query result.
- `Search` accepts structured criteria and owns sorting, pagination, and totals. The generated HTTP operation is commonly named `Query` and uses `POST` with a JSON body.
- Keep the application `List` and `Search` contracts separate when both behaviors are needed. Do not map a table screen to the lightweight list just because both return arrays.
- Define the query request and response schemas in the owning API generator. Do not assume every module uses the same filter fields or response envelope.

## Updates, authorization, and errors

- Use the HTTP method and operation contract defined by the owning generator. For PATCH operations with update masks, preserve the distinction between omitted fields and explicitly cleared nullable fields.
- Keep operation IDs and public schema identifiers stable when reorganizing generator files.
- Gate protected operations in the backend/application authorization flow. Keep documented status codes and error schemas aligned with middleware and gateway behavior.
- Generated API types belong at the transport boundary. Map them to application inputs and outputs in the gateway operation that uses them; keep HTTP types out of Domain and Application.

## Generated contracts

Change handwritten sources in the module's `Sources/Generators/<API>` target, then regenerate YAML and Swift output through that module's checked-in script or Make target. Do not edit generated YAML or Swift directly. See [module conventions](08-module-conventions.md) for target and file layout.
