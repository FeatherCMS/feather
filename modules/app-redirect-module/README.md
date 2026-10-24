# Redirect module

The Redirect module manages redirect rules. It exposes module, domain,
application, infrastructure, Admin API, app API, backend, and WebAdmin
products. Rules are persisted through Feather DBAL.

The Admin API keeps the lightweight `GET /rules` list distinct from the
filtered `POST /rules/query` search operation. They have separate schemas and
are intended for different UI needs. Public redirect resolution is exposed by
the app API and used by the backend redirect middleware.

## OpenAPI generation

The Swift generators live in `Sources/Generators/`; generated YAML is under
`openapi/`, and generated Swift API sources are under `Sources/APIs/`. Update
the Swift generator source and regenerate outputs; do not edit generated YAML
or Swift API files by hand.

Install Mint on macOS with Homebrew:

```sh
brew install mint
```

The script uses `swift-openapi-generator` 1.14.2 through Mint by default. It
installs that version on first use. `SWIFT_OPENAPI_GENERATOR_VERSION` changes
the pinned Mint version; `SWIFT_OPENAPI_GENERATOR_BIN` can point to an already
installed executable.

From this module directory:

```sh
# Generate OpenAPI YAML from the Swift generator sources.
make openapi-yaml

# Generate Swift API types from the YAML specifications.
make openapi-swift

# Run both generation steps in order.
make openapi
```

## OpenAPI documentation

```sh
make docker-openapi
```

The pinned `swaggerapi/swagger-ui:v5.32.15` services serve the Admin and app
specifications at `http://localhost:8889` and `http://localhost:8888`.

## Build and test

```sh
swift build
swift test --parallel
```

The Docker-based test service is also available with `make docker-test`.
