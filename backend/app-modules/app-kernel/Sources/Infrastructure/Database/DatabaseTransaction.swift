import Domain
import Application
import FeatherDatabase

public struct DatabaseExecutor<Context: Sendable>: Sendable {

    public let database: any DatabaseClient
    public let context: @Sendable (any DatabaseConnection) -> Context

    public init(
        database: any DatabaseClient,
        _ context: @Sendable @escaping (any DatabaseConnection) -> Context
    ) {
        self.database = database
        self.context = context
    }
}

public struct DatabaseTransactionExecutor<S: Scope>: TransactionExecutor {

    public let executor: DatabaseExecutor<S>

    public init(executor: DatabaseExecutor<S>) {
        self.executor = executor
    }

    public init(
        database: any DatabaseClient,
        scope: @Sendable @escaping (any DatabaseConnection) -> S
    ) {
        self.executor = .init(database: database, scope)
    }

    public func run<T: Sendable>(
        _ body: @Sendable (S) async throws -> T
    ) async throws -> T {
        try await executor.database.withTransaction { connection in
            try await body(executor.context(connection))
        }
    }
}

public struct DatabaseQueryExecutor<S: Scope>: QueryExecutor {

    public let executor: DatabaseExecutor<S>

    public init(executor: DatabaseExecutor<S>) {
        self.executor = executor
    }

    public init(
        database: any DatabaseClient,
        scope: @Sendable @escaping (any DatabaseConnection) -> S
    ) {
        self.executor = .init(database: database, scope)
    }

    public func run<T: Sendable>(
        _ body: @Sendable (S) async throws -> T
    ) async throws -> T {
        try await executor.database.withConnection { connection in
            try await body(executor.context(connection))
        }
    }
}
