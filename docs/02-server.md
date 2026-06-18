# FATHOMS Server Layer Guide

This guide explains the Server layer in `backend/Sources/Server`.

It focuses on two things:

1. How the server is assembled and built.
2. How the configuration layer feeds that build process.

## What You Will Accomplish

By the end of this guide, you will:

- Understand the startup flow from `main()` to a running HTTP server.
- Understand where server configuration is loaded and mapped.
- Understand what each folder in `Sources/Server` is responsible for.

## Key Points

- Assembly starts in `Entrypoint.swift`, then calls `ServerConfigLoader`, `buildServer`, and `buildRouter`.
- `AppInfrastructure` and `AppModules` wire runtime dependencies into use-case builders.
- `Routes+Build.swift` registers App and Admin OpenAPI handlers plus middleware.
- The configuration layer is small and explicit, based on scoped config readers.

---

## 1) Build and Assembly Flow

Server startup path:

```text
Entrypoint.main
   |
   v
ServerConfigLoader.load
   |
   v
buildServer(config)
   |
   +--> build logger + postgres client + database client
   +--> build AppInfrastructure
   +--> build AppModules
   +--> buildRouter(modules)
   |
   v
Application.runService
```

Snippet (`Entrypoint.swift`):

```swift
@main
struct Entrypoint {

    static func main() async throws {
        let config = try await ServerConfigLoader().load()
        let server = try await buildServer(config: config)
        try await server.runService()
    }
}
```

What this does:

1. Loads config first.
2. Builds the server application object.
3. Starts the service loop.

---

## 2) Configuration Layer

The Server configuration layer lives in `Sources/Server/Environment`.

### 2.1 Files

- `ServerConfig.swift`: the in-memory config model used by server build.
- `ServerConfigLoader.swift`: reads config values from environment/config files and builds `ServerConfig`.

Snippet (`ServerConfigLoader.swift`):

```swift
func load() async throws -> ServerConfig {
    let reader = try await environmentLoader.loadConfigReader(
        defaultEnvironmentFilePrefix: "server"
    )
    let system = systemConfigLoader.load(reader: reader)
    let serverHTTPReader = reader.scoped(to: "server.http")
    return .init(
        host: serverHTTPReader.string(forKey: "host", default: "127.0.0.1"),
        port: serverHTTPReader.int(forKey: "port", default: 8080),
        serverName: reader.string(forKey: "serverName"),
        system: system
    )
}
```

Why this matters:

- Config is centralized and explicit.
- Defaults are visible in one place.
- The build layer receives one typed object (`ServerConfig`).

---

## 3) Runtime Composition Layer

The composition layer wires infrastructure and modules.

### 3.1 AppInfrastructure

`AppInfrastructure` is the shared dependency bag passed to module builders.

```swift
struct AppInfrastructure: Sendable {
    let database: any DatabaseClient
    let idGenerator: any IDGenerator
}
```

### 3.2 Modules

`AppModules` constructs typed module builders (`system`, `user`, `auth`) from shared infrastructure.

```swift
struct AppModules: Sendable {
    let system: SystemModule
    let user: UserModule
    let auth: AuthModule
}
```

### 3.3 Builder pattern

Each module builder composes use-cases from executors + scopes.

Snippet (`SystemModule.makeAddVariable()`):

```swift
func makeAddVariable() -> AddVariable {
    let transaction = DatabaseTransactionExecutor(
        database: infrastructure.database,
        scope: { connection in
            WriteVariable(
                variable: DatabaseVariableRepository(connection: connection)
            )
        }
    )
    return .init(
        transaction: transaction,
        idGenerator: infrastructure.idGenerator
    )
}
```

This is the core assembly style used throughout Server.

---

## 4) Router and Middleware Assembly

`Routes+Build.swift` connects route handlers and middleware.

Main responsibilities:

- Create base router.
- Register shared middleware (logging, CORS).
- Register utility routes (`/health`).
- Register App and Admin OpenAPI handlers.

Snippet (trimmed):

```swift
let appAPI = AppAPI(modules: modules)
try appAPI.registerHandlers(
    on: router,
    middlewares: [
        ErrorMiddleware(),
        UnescapeHTTPHeadersMiddleware(),
    ]
)

let adminAPI = AdminAPI(modules: modules)
try adminAPI.registerHandlers(
    on: router,
    middlewares: [
        ErrorMiddleware(),
        UnescapeHTTPHeadersMiddleware(),
    ]
)
```

---

## 5) Server Components

This section describes the main server components, their purpose, and how they work together.

### 5.1 `Environment/`

Purpose: server-specific config model and loading.

- Converts raw config sources into typed runtime values.
- Keeps startup code clean by isolating config parsing.

How it works (short snippet):

```swift
let serverHTTPReader = reader.scoped(to: "server.http")
let host = serverHTTPReader.string(forKey: "host", default: "127.0.0.1")
let port = serverHTTPReader.int(forKey: "port", default: 8080)
```

### 5.2 `AppModules/`

Purpose: composition of feature module builders.

- `AppInfrastructure.swift`: shared runtime dependencies.
- `AppModules.swift`: module builder aggregator.
- `Builders/*.swift`: per-feature use-case assembly.

How it works (short snippet):

```swift
self.system = .init(infrastructure: infrastructure)
self.user = .init(infrastructure: infrastructure)
self.auth = .init(infrastructure: infrastructure)
```

### 5.3 `APIs`

Purpose: OpenAPI operation handlers.

- `APIs/App/`: app-facing API endpoints.
- `APIs/Admin/`: management/admin endpoints.
- Subfolders split endpoints by feature (`Auth`, `User`, `System`, etc.).
- API protocols are generated by Swift OpenAPI Generator from OpenAPI definition files (`.yaml` / `.json`).
- The OpenAPI definition is the shared contract used by both server and client apps.

How it works (short snippet):

```swift
struct AppAPI: APIProtocol {
    let modules: AppModules
}
```

Example handler implementation (`system.variable` get endpoint):

```swift
func systemVariableGet(
    _ input: Operations.SystemVariableGet.Input
) async throws -> Operations.SystemVariableGet.Output {
    let useCase = modules.system.makeGetVariable()
    let result = try await useCase.execute(
        .init(id: input.path.systemVariableId)
    )

    return .ok(
        .init(
            body: .json(map(result))
        )
    )
}
```

What this handler does:

1. Receives the generated OpenAPI operation input type.
2. Builds the matching use-case from the module builder.
3. Executes business logic using path parameters.
4. Maps result DTO into the generated OpenAPI response schema.
5. Returns a typed `.ok` OpenAPI output.

### 5.4 `Middlewares/`

Purpose: cross-cutting request/response behavior.

- `ErrorMiddleware.swift`: maps errors to HTTP responses.
- `UnescapeHTTPHeadersMiddleware.swift`: decodes/validates select response headers.
- `AuthMiddleware.swift`, `SessionSlidingExpirationMiddleware.swift`: currently mostly commented scaffolding for future auth/session policy wiring.

How it works (short snippet):

```swift
response.headerFields[fieldName] = decodeAndValidate(field)
```

### 5.5 `Errors/`

Purpose: error contracts and formatting.

- `HTTPErrorRepresentable.swift`: protocol to map errors to HTTP metadata/content.
- `Errors/Details/*`: serializable/public error detail shapes.
- `Errors/Trace/*`: nested trace model for debug trace trees.

How it works (short snippet):

```swift
try container.encode(code.code, forKey: .code)
try container.encode(message, forKey: .message)
```

#### `ErrorTrace`

`ErrorTrace` is the debug tree for failures.
It keeps the error type, message, and nested causes, so one top-level failure can show the full chain behind it.

Snippet (`Errors/Trace/ErrorTrace.swift`, trimmed):

```swift
public struct ErrorTrace: Encodable {
    public let type: Any
    public let logMessage: String
    public let children: [ErrorTrace]
}
```

To plug an error into tracing, conform it to `ErrorTraceRepresentable`.

Example from this codebase (`Variable.Error`):

```swift
extension Variable.Error: ErrorTraceRepresentable {
    public var underlyingErrors: [any Error] { [] }

    public func trace() -> ErrorTrace {
        .init(
            type: type(of: self),
            logMessage: String(describing: self),
            children: underlyingTraces()
        )
    }
}
```

#### `HTTPErrorRepresentable` 

`HTTPErrorRepresentable` maps a domain or application error to an HTTP response shape.
It tells middleware which status code, headers, and optional body should be returned.

Protocol shape (trimmed):

```swift
protocol HTTPErrorRepresentable: Error {
    associatedtype Content: Encodable
    var status: HTTPResponseStatus { get }
    var headers: HTTPHeaders? { get }
    var content: Content? { get }
}
```

Example adaptation for `Variable.Error`:

```swift
extension Variable.Error: HTTPErrorRepresentable {
    var status: HTTPResponseStatus { .badRequest }

    var content: ServerError.Details? {
        .init(
            code: .badRequest,
            message: "\(self)",
            reason: "\(self)"
        )
    }
}
```

How both pieces work together:

1. Your use-case or repository throws `Variable.Error`.
2. `ErrorTraceRepresentable` provides a trace tree for debug output.
3. `HTTPErrorRepresentable` provides response status/body mapping.
4. `ErrorMiddleware` returns JSON or plain text based on request headers.

### 5.6 `Adapters/`

Purpose: bridge server layer to other contracts.

- `Adapters/Infrastructure/`: concrete server-side implementations for kernel app ports (`IDGenerator`, `PasswordHasher`, `MailSender`).
- `Adapters/Error/`: trace adapters for domain/infrastructure error types.
- `Adapters/DTO+Schema/`: schema mapping helpers between application DTOs and OpenAPI schema objects.

#### Infrastructure adapters

These adapters connect abstract application contracts to concrete libraries.

Examples in this project:

- `NanoIDGenerator` implements `IDGenerator`.
- `BcryptPasswordHasher` implements `PasswordHasher`.
- `FeatherMailSender` implements `MailSender`.

How it works (short snippet):

```swift
struct NanoIDGenerator: IDGenerator {
    func generate() -> String { NanoID().rawValue }
}
```

Why this matters:

- Use-cases depend on interfaces, not libraries.
- Server assembly chooses concrete implementations in one place.
- Swapping implementations stays localized to adapters and wiring.

#### Error adapters

Error adapters normalize different error sources into one traceable shape.

Examples:

- `System+Variable+Error+Trace.swift` adapts domain variable errors.
- `DatabaseError+Trace.swift` adapts persistence errors.
- `ServerError+Trace.swift` adapts transport/runtime errors.

These adapters make `ErrorMiddleware` output consistent details even when failures come from different layers.

#### DTO + schema adapters

DTO/schema adapters convert between internal application DTOs and OpenAPI request/response schema types.

Typical mapping responsibilities:

1. Convert request schema -> application query/input DTO.
2. Convert application detail/list DTO -> response schema.
3. Map enums and pagination/sort objects safely.

In this repository, some DTO+schema files are still in-progress or commented out, but the pattern is visible in helper mapping code under `APIs/Admin/AdminAPI+Helpers.swift`.

Example DTO adapter snippet (schema -> application query DTO):

```swift
func map(
    _ query: Components.Schemas.SystemVariableListItemSearchQuerySchema
) -> VariableList.Query {
    let sort = (query.sort ?? []).map { rule in
        let field: VariableList.Query.Sort.Field
        switch rule.field {
        case .id: field = .id
        case .name: field = .name
        case .value: field = .value
        case .notes: field = .notes
        }
        return VariableList.Query.Sort(
            field: field,
            direction: mapSortDirection(rule.direction)
        )
    }

    return .init(
        page: map(query.page),
        sort: sort,
        search: query.filters.search
    )
}
```

This adapter keeps controllers thin by moving request-shape conversion into a dedicated mapping function.

#### End-to-end adapter flow

```text
HTTP/OpenAPI schema
   |
   v
Controller mapping helper (schema -> DTO)
   |
   v
Use-case call (ports only)
   |
   v
Infrastructure adapter (ID/hash/mail/db)
   |
   v
Domain/DB result
   |
   v
Controller mapping helper (DTO -> schema)
   |
   v
HTTP response
```

---

## 6) Mental Model

The Server layer is the outer assembly shell.

- It does not own core business rules.
- It owns runtime construction, routing, adapters, and delivery concerns.
- It translates HTTP and infrastructure concerns into module use-case calls.

If you remember this split, server changes stay clean and predictable.
