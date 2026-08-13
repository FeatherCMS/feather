//
//  DatabaseTransactionExecutor.swift
//  feather-core
//

import FeatherApplication
import FeatherContracts
import FeatherDatabase
import FeatherDomain

public struct DatabaseTransactionExecutor<S: Scope>:
    ContextualTransactionExecutor
{

    public let executor: DatabaseExecutor<S, DatabaseTransactionContext>
    public let idGenerator: any IDGenerator

    public init(
        executor: DatabaseExecutor<S, DatabaseTransactionContext>,
        idGenerator: any IDGenerator
    ) {
        self.executor = executor
        self.idGenerator = idGenerator
    }

    public init(
        database: any DatabaseClient,
        idGenerator: any IDGenerator,
        scope: @Sendable @escaping (DatabaseTransactionContext) -> S
    ) {
        self.executor = .init(
            database: database,
            scope: scope
        )
        self.idGenerator = idGenerator
    }

    public func run<T: Sendable>(
        _ body: @Sendable (S) async throws -> T
    ) async throws -> T {
        try await executor.database.withTransaction { connection in
            let context = context(for: connection)
            return try await body(executor.scope(context))
        }
    }

    public func run<T: Sendable>(
        _ body: @Sendable (S, any TransactionContext) async throws -> T
    ) async throws -> T {
        try await executor.database.withTransaction { connection in
            let context = DatabaseTransactionContext(
                connection: connection,
                idGenerator: idGenerator
            )
            return try await body(executor.scope(context), context)
        }
    }

    private func context(
        for connection: any DatabaseConnection
    ) -> DatabaseTransactionContext {
        .init(connection: connection, idGenerator: idGenerator)
    }
}
