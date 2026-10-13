# Events and Transactional Hooks

This document records the event-system design discussed for Feather modules. It
describes the current implementation, the problems it creates, and the
proposed direction for transactional hooks and result-producing events.

## Design goals

The event system should:

- keep feature repositories in transaction scopes;
- keep event invocation as a direct use-case dependency;
- execute transactional handlers using the connection of the current transaction;
- support multiple handlers for one event;
- collect typed handler results in registration order;
- avoid stringly typed event arguments and `Any` at the public API boundary;
- let modules register their own hooks without application-specific ceremony;
- avoid requiring a global or task-local “current database connection”.

## Current implementation

The event infrastructure now contains:

- `Event`: a marker protocol for sendable events;
- `EventPublisher`: triggers events and collects handler results;
- `EventRegistry`: stores and triggers handlers by event type;
- `EventRegistry`: registers and stores handlers;
- `AnyEventHandler`: type-erases event handlers internally;
- `ExecutionContext`: the shared opaque application-layer execution context;
- `TransactionContext` and `QueryContext`: execution-mode-specific contexts;
- `DatabaseTransactionContext`: the database implementation carrying the active connection;
- `DatabaseQueryContext`: the query implementation carrying the active connection;
- `EventError` for handler failures and registry type mismatches.

The previous account-creation scope contained both repositories and an event
dispatcher. It looked like this:

```swift
public struct WriteAccountCreation: Scope {
    public let account: any AccountRepository
    public let events: any EventDispatcher
}
```

The module builder creates both values from the same database connection:

```swift
DatabaseTransactionExecutor(
    database: database,
    scope: { connection in
        WriteAccountCreation(
            account: AccountDatabaseRepository(
                connection: connection
            ),
            events: eventDispatcher(connection)
        )
    }
)
```

That design exposed a connection-bound dispatcher as part of a feature scope,
mixing feature dependencies with transaction-runtime dependencies. The current
implementation removes the dispatcher from the scope and injects an
`EventPublisher` directly into event-using use cases.

## How the current connection is preserved

`DatabaseTransactionExecutor` opens the transaction and receives a database
connection:

```swift
try await database.withTransaction { connection in
    let scope = scopeFactory(connection)
    return try await body(scope)
}
```

The current event wiring creates a `DatabaseTransactionContext` from that same
connection. When a handler runs, it receives the same connection before the
`withTransaction` closure returns.

The current flow is:

```text
withTransaction
    |
    +-- DatabaseConnection
    |      |
    |      +-- repository scope
    |      +-- database transaction context
    |
    +-- use-case transaction body
           |
           +-- repository operation
           +-- event dispatch
                  |
                  +-- handler using the same connection
```

There is no connection lookup or ambient global state. The connection is
captured and passed through closures. This preserves the transaction boundary,
but the mechanism is hidden in the scope.

## Proposed dependency split

The feature scope should contain repositories only:

```swift
public struct WriteAccountCreation: Scope {
    public let account: any AccountRepository
}
```

The use case should own an event publisher directly:

```swift
public struct AddAccount: UseCase {
    let transaction: any ContextualTransactionExecutor<WriteAccountCreation>
    let events: any EventPublisher
}
```

The publisher remains reusable. The transaction context is created for each
transaction execution and is never stored in the use case or module.

## Transaction context

The application layer defines an opaque transaction-context contract:

```swift
public protocol ExecutionContext: Sendable {}

public protocol TransactionContext: ExecutionContext {}

public protocol QueryContext: ExecutionContext {}
```

The database infrastructure provides the concrete context:

```swift
import FeatherDatabase

public struct DatabaseTransactionContext: TransactionContext {
    public let connection: any DatabaseConnection

    public init(
        connection: any DatabaseConnection
    ) {
        self.connection = connection
    }
}

public struct DatabaseQueryContext: QueryContext {
    public let connection: any DatabaseConnection
}
```

`DatabaseTransactionContext` is short-lived. It must not be stored after the
transaction closure completes.

Event-using transactions use a contextual transaction-executor protocol. The
existing `TransactionExecutor` API remains available for transactions that do
not need a transaction context, which avoids changing every existing use-case
closure at once:

```swift
public protocol ContextualExecutor<S, Context>: Executor
where S: Scope {
    func run<T: Sendable>(
        _ body: @Sendable (S, Context) async throws -> T
    ) async throws -> T
}

public protocol ContextualTransactionExecutor<S>:
    TransactionExecutor,
    ContextualExecutor<S, any TransactionContext>
{}
```

The database implementation creates the concrete context:

```swift
public struct DatabaseTransactionExecutor<S: Scope>:
    TransactionExecutor, ContextualTransactionExecutor
{
    private let database: any DatabaseClient
    private let scopeFactory: @Sendable (
        any DatabaseConnection
    ) -> S

    public func run<T: Sendable>(
        _ body: @Sendable (
            S,
            any TransactionContext
        ) async throws -> T
    ) async throws -> T {
        try await database.withTransaction { connection in
            let scope = scopeFactory(connection)
            let context = DatabaseTransactionContext(
                connection: connection
            )

            return try await body(scope, context)
        }
    }
}
```

`DatabaseTransactionExecutor` conforms to both executor forms. Event-using
use-cases depend on `ContextualTransactionExecutor`; other use-cases can keep
using `TransactionExecutor` until they need a transaction context.

This keeps the connection out of the feature scope while still making its
lifetime explicit.

Queries can expose the same execution context pattern without claiming to be
inside a transaction:

```swift
public protocol ContextualQueryExecutor<S>:
    QueryExecutor,
    ContextualExecutor<S, any QueryContext>
{}

public struct DatabaseQueryExecutor<S: Scope>:
    QueryExecutor, ContextualQueryExecutor
{
    public func run<T: Sendable>(
        _ body: @Sendable (
            S,
            any QueryContext
        ) async throws -> T
    ) async throws -> T {
        try await database.withConnection { connection in
            try await body(
                scopeFactory(connection),
                DatabaseQueryContext(connection: connection)
            )
        }
    }
}
```

An event fired from a query receives `DatabaseQueryContext`; an event fired
from a transaction receives `DatabaseTransactionContext`. Both are accepted
by `EventPublisher` through their shared `ExecutionContext` interface.

## Event publisher

The use-case-facing protocol triggers all matching handlers and returns their
results:

```swift
public protocol EventPublisher: Sendable {
    @discardableResult
    func trigger<E: Event>(
        event: E,
        using context: any ExecutionContext,
        contextPolicy: EventContextPolicy = .strict,
        invocationPolicy: EventInvocationPolicy = .all
    ) async throws -> [E.Output]
}
```

Callers can ignore the returned array for events whose results are not needed.

Context matching is strict by default:

```swift
public enum EventContextPolicy: Equatable, Sendable {
    case strict
    case skipIncompatible
}
```

`strict` throws when a registered handler requires a different context type.
`skipIncompatible` ignores that handler and continues with later compatible
registrations for the same event.

Invocation can target every compatible handler or stop after the first one:

```swift
public enum EventInvocationPolicy: Equatable, Sendable {
    case all
    case first
}
```

```swift
let result = try await events.trigger(
    event: AccountCreationValidation(),
    using: transactionContext,
    invocationPolicy: .first
)
```

The publisher validates that the supplied transaction context is compatible
with its registry. An incompatible context is a configuration/programming
error and should produce a typed error rather than opening a new connection.

## Typed event results

Each event declares the result returned by one handler:

```swift
public protocol Event: Sendable {
    associatedtype Output: Sendable = Void
}
```

A normal transactional hook uses `Void`:

```swift
public struct UserAccountDidInsert: Event {
    public typealias Output = Void

    public let accountID: String
}
```

A result-producing event declares its result type:

```swift
public struct AccountCreationValidation: Event {
    public typealias Output = ValidationResult
}
```

Handlers for the same event must return the same output type:

```swift
registry.register(
    event: AccountCreationValidation.self,
    context: DatabaseTransactionContext.self
) { event, context in
    ValidationResult(...)
}
```

Dispatching returns one value per handler in registration order:

```swift
let results: [ValidationResult] = try await events.trigger(
    event: AccountCreationValidation(),
    using: transactionContext
)
```

The internal type-erased handler may store its result as `any Sendable`, but
the registry must restore and verify `E.Output` before returning it. A result
type mismatch should produce a typed registry error.

For `Void` events, callers use:

```swift
try await events.trigger(
    event: UserAccountDidInsert(accountID: account.id),
    using: transactionContext
)
```

## Multiple values per handler

The base result is one result per handler:

```text
[HandlerResult]
```

If one handler contributes multiple values, the event can define an array
output:

```swift
public struct AdditionalAdminLinks: Event {
    public typealias Output = [AdminLink]
}
```

The raw result is then:

```swift
[[AdminLink]]
```

Flattening should be an explicit operation rather than an automatic behavior:

```swift
public func triggerFlattened<E: Event, Item>(
    _ event: E,
    using context: any ExecutionContext
) async throws -> [Item]
where E.Output == [Item]
```

This keeps `trigger` predictable and still supports the `invokeAll` style of
collecting contributions.

## Removing the registry context generic

The registry is non-generic:

```swift
var events = EventRegistry()
```

This means that the registry itself does not have one global context type. Each
registration can declare the context type used by its handler:

```swift
var events = EventRegistry()

events.register(
    event: UserAccountDidInsert.self,
    context: DatabaseTransactionContext.self
) { event, context in
    ...
}

registry.register(
    event: SomeOtherEvent.self,
    context: AnotherTransactionContext.self
) { event, context in
    ...
}
```

The context type is supplied at the individual `register` call. This preserves
typed handler contexts without forcing `EventRegistry<Context>` at the
application level.

The registration method remains generic over its event and context types:

```swift
public mutating func register<
    E: Event,
    Context: ExecutionContext
>(
    event: E.Type,
    context: Context.Type,
    handler: @Sendable @escaping (
        E,
        Context
    ) async throws -> E.Output
)
```

The call site supplies both type witnesses, allowing Swift to infer the
closure parameter types:

```swift
registry.register(
    event: UserAccountDidInsert.self,
    context: DatabaseTransactionContext.self
) { event, context in
    try await AccountSettingsEventHandlers.createDefaultSettings(
        event: event,
        context: context
    )
}
```

Internally, handlers are type-erased to accept:

```swift
any Event
any ExecutionContext
```

The type-erased wrapper checks both the event type and the context type before
invoking the typed closure.

In practical terms, one non-generic registry can contain handlers such as:

```text
non-generic registry
    ├─ transaction hook → DatabaseTransactionContext
    ├─ query hook       → DatabaseQueryContext
    └─ other hook       → AnotherExecutionContext
```

If Feather uses only `DatabaseTransactionContext`, the simpler global-generic
form is also valid:

```swift
var events = EventRegistry<DatabaseTransactionContext>()
```

The non-generic registry is useful when one registry must support handlers
with different context types. It is not required merely to support typed
handlers.

This is a reasonable compromise:

- no application-wide `EventRegistry<Context>` generic;
- typed context at each registration site;
- no `Any` in the public registration closure;
- type checks remain at the type-erasure boundary.

## Removing handler IDs

Handler IDs are not required if the registry is an ordered collection and
multiple handlers for the same event are expected.

The simpler registration API is:

```swift
registry.register(
    event: UserAccountDidInsert.self,
    context: DatabaseTransactionContext.self
) { event, context in
    ...
}
```

Dispatch order is registration order. Duplicate-handler errors and
`require(event:id:)` are removed.

Errors report the event type and the underlying handler error.

## Registration ceremony

The application composition layer only combines module-owned registrations:

```swift
AccountSettingsEventHandlers.registerHooks(
    in: &eventHandlers
)
```

There is no separate `require` operation. Registration is non-throwing and
handlers are retained in registration order.

The preferred module-owned registration shape is:

```swift
public enum AccountSettingsEventHandlers {
    public static func registerHooks(
        in registry: inout EventRegistry
    ) {
        registry.register(
            event: UserAccountDidInsert.self,
            context: DatabaseTransactionContext.self
        ) { event, context in
            try await AccountSettingsEventHandlers.createDefaultSettings(
                event: event,
                context: context
            )
        }
    }
}
```

Composition then becomes:

```swift
var events = EventRegistry()

AccountModule.registerHooks(
    in: &registry
)

let eventPublisher: any EventPublisher = registry
```

The module owns its hook implementation. The application owns composition.

## Transactional behavior

Immediate event dispatch is appropriate when the handler must be atomic with
the originating write:

```text
insert account
    |
    +-- trigger UserAccountDidInsert
            |
            +-- create account settings
    |
commit
```

If the handler throws, the error exits `withTransaction` and the originating
write rolls back with the handler's write.

The event system must not create a new database connection for a handler that
was fired inside a transaction. The handler must use the connection carried by
the transaction context.

A transaction context may only be used inside the structured, awaited
transaction call tree. Handlers must not retain it, pass it to a detached task,
queue it for later work, or use it after the transaction closure returns. Work
that must happen after commit should use an outbox or job payload containing
value data rather than a database connection.

For work that should happen only after commit, use an outbox or job queue
instead. The in-transaction event system should not be treated as a durable
event bus.

## Migration sequence

The implementation can be migrated incrementally:

1. Add `ExecutionContext`, `TransactionContext`, and `QueryContext` to
   `FeatherApplication`.
2. Add `DatabaseTransactionContext` and `DatabaseQueryContext` to
   `FeatherInfrastructure`.
3. Add contextual transaction and query executors and provide the context only
   to event-using operations.
4. Remove `events` from `WriteAccountCreation` and `WriteInvitation`.
5. Rename the use-case dependency to `EventPublisher`.
6. Add typed-result `trigger` API.
7. Make the registry non-generic and mutable during composition.
8. Make `register` generic over the context per call.
9. Remove handler IDs and `require` from the local registry.
10. Move registrations into module-owned `registerHooks` methods.
11. Migrate account and invitation use cases.
12. Add tests for same-connection execution, result ordering, result type
    errors, context type errors, and rollback on handler failure.

## Feasibility assessment

The approach is feasible and aligns with the existing FATHOMS boundaries.

The main API change is that `TransactionExecutor` must expose a second value
to its body: the transaction context. The registry's context generic can then
be removed without losing typed registration closures.

The two deliberate type-erasure boundaries are:

1. `any ExecutionContext` at the execution/event publisher boundary;
2. `any Event` and `any Sendable` inside the event registry.

Both boundaries are checked immediately before invoking a handler or returning
results. No dynamic string-based event arguments are required.
