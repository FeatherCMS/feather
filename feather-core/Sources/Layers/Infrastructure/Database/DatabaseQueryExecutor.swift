//
//  DatabaseQueryExecutor.swift
//  feather-core
//

import FeatherApplication
import FeatherContracts
import FeatherDatabase

public struct DatabaseQueryExecutor<S: Scope>:
    ContextualQueryExecutor
{

    public let executor: DatabaseExecutor<S, DatabaseQueryContext>

    public init(executor: DatabaseExecutor<S, DatabaseQueryContext>) {
        self.executor = executor
    }

    public init(
        database: any DatabaseClient,
        scope: @Sendable @escaping (DatabaseQueryContext) -> S
    ) {
        self.executor = .init(
            database: database,
            scope: scope
        )
    }

    public func run<T: Sendable>(
        _ body: @Sendable (S) async throws -> T
    ) async throws -> T {
        try await executor.database.withConnection { connection in
            let context = DatabaseQueryContext(connection: connection)
            return try await body(executor.scope(context))
        }
    }

    public func run<T: Sendable>(
        _ body: @Sendable (S, any QueryContext) async throws -> T
    ) async throws -> T {
        try await executor.database.withConnection { connection in
            let context = DatabaseQueryContext(connection: connection)
            return try await body(
                executor.scope(context),
                context
            )
        }
    }
}
