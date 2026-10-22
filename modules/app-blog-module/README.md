# Feather Blog Module

The Blog module provides public blog content and authenticated administration
for posts, authors, author links, tags, and blog URL settings. It integrates
with the Web and Media modules for content metadata and media assets.

## Package targets

- `BlogModule`: public module namespaces, permissions, and events.
- `BlogDomain`, `BlogApplication`, and `BlogInfrastructure`: domain,
  application, and persistence layers.
- `BlogAdminAPI` and `BlogAppAPI`: generated OpenAPI clients and routers.
- `BlogBackend`: backend gateways and use-case composition.
- `BlogWebApp`, `BlogWebAdmin`, and `BlogWebShared`: app-facing routes,
  administration UI composition, and transport shared by those web targets.

## OpenAPI

Regenerate the YAML specifications and Swift clients with:

```sh
make openapi
```

The script uses Mint to run `swift-openapi-generator` 1.14.2. You can run only
the document generators with `make openapi-yaml`, or only generate Swift API
types with `make openapi-swift`. The source specifications are in `openapi/`;
generated Swift files under `Sources/APIs/` should not be edited manually.

The Admin and App Swagger UI instances are available on ports 8889 and 8888:

```sh
make docker-openapi
```

## Build and tests

```sh
swift build
swift test --parallel
make docker-test
```

The Docker test image uses Swift 6.3 and runs the package tests without a
database service. Database behavior is tested through the shared mock database
and DBAL platform; real database-driver integration belongs in integration
tests.
