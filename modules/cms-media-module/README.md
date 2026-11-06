# Feather Media Module

The Media module provides media asset and folder management, variant
configuration and generation, and the admin APIs and pages used to manage
those resources. Its application layer depends on the Media domain contracts;
infrastructure persists metadata and coordinates file storage through
`FeatherStorage`.

## Package products

- `MediaModule`: public module namespaces, events, and permissions.
- `MediaDomain`: media models and repository contracts.
- `MediaApplication`: use cases, operation inputs, and application contracts.
- `MediaInfrastructure`: database adapters, migrations, storage adapters, and
  background job handling.
- `MediaAdminAPI` and `MediaAppAPI`: generated OpenAPI client/server types.
- `MediaBackend`: HTTP gateways and application use-case construction.
- `MediaWebAdmin`: admin pages, routes, and the admin API client.
- `MediaAdminOpenAPIGenerator` and `MediaAppOpenAPIGenerator`: generators for
  the module-owned OpenAPI documents.

## Build and test

Use Swift 6.3 or newer:

```sh
swift build
swift test --parallel
```

The Docker test image runs the same package tests without requiring a database
service:

```sh
make docker-test
```

## OpenAPI

The source specifications are generated from the Swift generator targets.
Regenerate both the YAML documents and Swift API sources with:

```sh
make openapi
```

The individual `openapi-yaml` and `openapi-swift` targets can be used when only
one generation step is needed. Do not edit generated Swift API files by hand.

To serve the generated admin specification locally with Swagger UI:

```sh
make docker-openapi
```

The UI is served on port `8889` and reads the checked-in OAS 3.2 document.
