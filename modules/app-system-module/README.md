# System module

The System module provides the application's shared system features:

- permission, variable, and background job models and use cases;
- database persistence and migrations for system data;
- an Admin API for managing permissions and variables and viewing jobs;
- module permission keys and seed definitions used by the application.

The Swift package exposes separate products for the module contracts, domain,
application, infrastructure, Admin API, backend composition, and frontend
composition. Applications can depend on the layers they need and compose the
backend or frontend integrations at their own boundary.

## OpenAPI generation

The Admin API specification is generated from the Swift API generator in
`Sources/Generators/Admin/Entrypoint.swift`. The generated YAML files live in
`openapi/`; generated Swift API types live in `Sources/APIs/Admin/`. Do not edit
these generated files by hand. Change the Swift generator or its inputs, then
regenerate them.

### Install Mint and swift-openapi-generator

Install [Mint](https://github.com/yonaskolb/Mint) on macOS with Homebrew:

```sh
brew install mint
```

The generation script pins `apple/swift-openapi-generator` to version `1.14.2`
by default. Mint installs and runs that version on the first generation, so a
separate generator installation is not required. To install it ahead of time:

```sh
mint install apple/swift-openapi-generator@1.14.2
```

Run the following commands from this module's directory:

```sh
# Generate OpenAPI YAML from the Swift generator.
make openapi-yaml

# Generate Swift API types from openapi/system-admin.yaml.
make openapi-swift

# Run both generation steps in order.
make openapi
```

The YAML step writes `system-admin.yaml`, `system-admin@v3_1_0.yaml`, and
`system-admin@v3_2_0.yaml`. The Swift API generation step uses the base
`system-admin.yaml` and the settings in
`scripts/openapi-generator-config.yml`, writing its output to
`Sources/APIs/Admin/`.

The generator version can be overridden with `SWIFT_OPENAPI_GENERATOR_VERSION`.
If the executable is already installed outside Mint, set
`SWIFT_OPENAPI_GENERATOR_BIN` to its command name or path.

### View the Admin API documentation

Start the Swagger UI container from the module directory:

```sh
make docker-openapi
```

Open <http://localhost:8889>. The service uses the published
`swaggerapi/swagger-ui:v5.32.15` image and mounts
`openapi/system-admin@v3_2_0.yaml` as the image's
`/app/system-admin@v3_2_0.yaml`. The image serves that file at
`/system-admin@v3_2_0.yaml`;
no local Swagger UI download or custom Nginx configuration is needed.

## Build and test

```sh
swift build
swift test --parallel
```

The module also provides a Docker-based test service:

```sh
docker compose run --rm --build tests
```
