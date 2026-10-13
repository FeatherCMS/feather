//
//  DatabaseTransactionExecutor.swift
//  feather-core
//

public import FeatherContracts
import FeatherDatabase
public import FeatherDomain

public struct DatabaseTransactionExecutor<S: Scope>:
    ContextualTransactionExecutor
{

    public let executor: DatabaseExecutor<S, DatabaseTransactionContext>
    public let databaseContext: DatabaseClientContext
    public var idGenerator: any IDGenerator { databaseContext.idGenerator }

    public init(
        executor: DatabaseExecutor<S, DatabaseTransactionContext>,
        databaseContext: DatabaseClientContext
    ) {
        self.executor = executor
        self.databaseContext = databaseContext
    }

    public init(
        databaseContext: DatabaseClientContext,
        scope: @Sendable @escaping (DatabaseTransactionContext) -> S
    ) {
        self.executor = .init(
            database: databaseContext.database,
            scope: scope
        )
        self.databaseContext = databaseContext
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
