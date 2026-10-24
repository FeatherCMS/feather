# User module

The User module provides user identity and role models, use cases, database
persistence, an Admin API, and a WebAdmin interface. The package exposes
separate products for the module contracts, domain, application,
infrastructure, Admin API, backend composition, and WebAdmin composition.

## OpenAPI generation

The Admin API specification is generated from the Swift generator in
`Sources/Generators/Admin/`. Generated YAML lives in `openapi/`, and generated
Swift API types live in `Sources/APIs/Admin/`. Do not edit generated files by
hand; change the Swift generator inputs and regenerate them.

Install [Mint](https://github.com/yonaskolb/Mint) on macOS with Homebrew:

```sh
brew install mint
```

The generation script runs
[`swift-openapi-generator` 1.14.2](https://github.com/apple/swift-openapi-generator)
through Mint by default, installing it on first use. Set
`SWIFT_OPENAPI_GENERATOR_VERSION` to override the pinned version, or
`SWIFT_OPENAPI_GENERATOR_BIN` to use an already installed executable.

Run these commands from this module's directory:

```sh
# Generate OpenAPI YAML from the Swift generator.
make openapi-yaml

# Generate Swift API types from openapi/user-admin.yaml.
make openapi-swift

# Run both generation steps in order.
make openapi
```

### View the Admin API documentation

```sh
make docker-openapi
```

Open <http://localhost:8889>. Swagger UI uses the pinned
`swaggerapi/swagger-ui:v5.32.15` image and serves
`openapi/user-admin@v3_2_0.yaml` directly; no local Swagger UI download or
custom Nginx configuration is needed.

## Build and test

```sh
swift build
swift test --parallel
```

The module also has a Docker-based test service:

```sh
make docker-test
```
