# Contact module

The Contact module provides feature contracts, domain and application logic, persistence adapters, and the API or web composition it owns. Packages separate these responsibilities into Swift targets. Target names and owned surfaces vary by module; use only the products needed by the application layer being integrated.

## OpenAPI generation

When a module owns OpenAPI APIs, their specifications are generated from Swift sources in `Sources/Generators/<API>`. Generated YAML lives in `openapi/`, and generated Swift clients and servers live in `Sources/APIs/<API>/`. Do not edit generated files manually.

Install Mint and run the pinned `swift-openapi-generator` through the module scripts:

```sh
brew install mint
make openapi-yaml
make openapi-swift
make openapi
```

The YAML generation step writes base, OpenAPI 3.1, and OpenAPI 3.2 documents for each API the module owns. Swift generation reads the base documents and writes to the matching `Sources/APIs/<API>/` directory.

## API documentation containers

Start the pinned Swagger UI containers from the module directory:

```sh
make docker-openapi
```

The module's Admin and App specifications, where present, are served on ports `8889` and `8888`, respectively. Services use `swaggerapi/swagger-ui:v5.32.15` and mount the OpenAPI 3.2 YAML directly; no local Swagger UI download, custom Nginx configuration, or spec conversion is needed.

## Build and test

Use Swift 6.3 or newer from the module directory:

```sh
swift build
swift test --parallel
```

Ordinary package tests use the shared mock database setup and do not require a PostgreSQL container.
