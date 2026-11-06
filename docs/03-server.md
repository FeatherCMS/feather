# Server guide

The backend runtime is composed in `application/Sources/Server`. The package manifest defines the executable targets and dependencies.

## Startup flow

```text
Entrypoint.main
  -> ServerConfig.Loader.load()
  -> buildServer(config:)
  -> buildRouter(modules:)
  -> runService()
```

`Server/Entrypoint.swift` loads configuration and starts the service. `Server/Server+Build.swift` builds logging, database, storage, job queue, and application dependencies.

## Configuration

Server configuration is owned by the Server target:

- `Server/Config/ServerConfig.swift` defines the typed runtime configuration.
- `Server/Config/ServerConfig+Loader.swift` reads values from environment variables and the selected env file.

The loader reads `server.<environment>.env`, defaulting to `server.dev.env`. Use `--env stage` to select another environment and `--env-file-path <path>` to load an explicit file. See [environment configuration](04-environment.md) for the executable env files and public URL variables.

Each other executable owns its own config type and loader; do not reintroduce a shared application-wide Environment target.

## Runtime composition

`Server/Modules/AppInfrastructure.swift` groups shared runtime dependencies, including the database context, event publisher, job queue, and storage context. `AppModules.swift` constructs the feature module use-case builders and shared authorizer.

`Server/Modules/Routes+Build.swift` installs common middleware, registers `/health`, and registers the module-owned Admin and App API gateways. Middleware handles cross-cutting concerns such as error translation and authentication.

## Where to change code

- Change a feature's business behavior in its owning module, not in Server route wiring.
- Change module construction in `AppModules.swift` when a runtime dependency or module builder changes.
- Change top-level API registration or common middleware in `Routes+Build.swift`.
- Keep Server-specific parsing and error adapters under `Server/Config`, `Server/Errors`, and `Server/Middlewares`.

See [module conventions](08-module-conventions.md) for module composition boundaries and [environment configuration](04-environment.md) for local settings.
