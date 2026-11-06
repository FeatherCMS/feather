# Account module

The Account module provides account-profile and settings management, account
registration, and invitation lifecycle features. It composes with Auth, User,
System, and Media for identity credentials, roles, system configuration, and
profile assets.

The package separates module/domain/application/infrastructure, backend
composition, generated Admin and App APIs, and their corresponding WebAdmin and
WebApp composition targets. Use only the products needed by the application
layer being integrated.

## OpenAPI generation

The Admin and App OpenAPI specifications are generated from Swift sources in
`Sources/Generators/Admin` and `Sources/Generators/App`. Generated YAML lives in
`openapi/`; generated Swift clients/servers live in `Sources/APIs/`. Do not edit
generated files manually.

Install Mint and run the pinned `swift-openapi-generator` through the module
scripts:

```sh
brew install mint
make openapi-yaml
make openapi-swift
make openapi
```

The YAML generation step writes base, OpenAPI 3.1, and OpenAPI 3.2 documents for
both APIs. Swift generation reads the base documents and writes to the matching
`Sources/APIs/{Admin,App}` directory.

## API documentation containers

Start the pinned Swagger UI containers from this directory:

```sh
make docker-openapi
```

The Admin and App specs are served on ports `8889` and `8888`. Both services use
`swaggerapi/swagger-ui:v5.32.15` and mount the OpenAPI 3.2 YAML directly; no local
Swagger UI download, custom Nginx config, or spec conversion is needed.

## Build and test

```sh
swift build
swift test --parallel
```

The package's `tests` Docker service uses the Swift 6.3 image and the same mock
database test setup as local tests; it does not require a PostgreSQL container.
