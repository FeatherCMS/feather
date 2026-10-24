# Feather Web Module

The Web module provides the CMS website's public content and administration
features: pages, menus and menu items, metadata, and site settings. Its package
separates domain, application, persistence, HTTP APIs, backend composition, and
the WebApp/WebAdmin presentation surfaces.

## OpenAPI generation

The module owns separate Admin and App OpenAPI specifications. To regenerate
their YAML and Swift client/server types, install `swift-openapi-generator` and
run:

```sh
make openapi
```

Use `make openapi-yaml` to regenerate only the YAML documents, or
`make openapi-swift` to regenerate only the Swift API sources.

## API documentation

The Compose file serves the versioned OpenAPI 3.2 specifications with the
upstream Swagger UI image:

```sh
docker compose up openapi-app openapi-admin
```

Then open the App specification at `http://localhost:8888` and the Admin
specification at `http://localhost:8889`. The services mount the checked-in
`@v3_2_0` YAML documents read-only; Swagger UI is pinned to `v5.32.15`.

## Tests

Run package tests with `swift test --parallel`. The Docker test service is
available through `make docker-test`; it runs the package's mock-backed tests
without requiring a PostgreSQL service.
