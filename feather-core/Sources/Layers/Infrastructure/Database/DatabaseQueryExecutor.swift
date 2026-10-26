//
//  DatabaseQueryExecutor.swift
//  feather-core
//

public import FeatherModuleKit
public import FeatherDBAL
import FeatherDatabase
public import FeatherDomain

public struct DatabaseQueryExecutor<S: Scope>:
    ContextualQueryExecutor
{

    public let executor: DatabaseExecutor<S, DatabaseQueryContext>
    public let idGenerator: any IDGenerator
    public let platform: any DatabasePlatform

    public init(
        executor: DatabaseExecutor<S, DatabaseQueryContext>,
        idGenerator: any IDGenerator,
        platform: any DatabasePlatform
    ) {
        self.executor = executor
        self.idGenerator = idGenerator
        self.platform = platform
    }

    public init(
        databaseContext: DatabaseClientContext,
        scope: @Sendable @escaping (DatabaseQueryContext) -> S
    ) {
        self.init(
            executor: .init(
                database: databaseContext.database,
                scope: scope
            ),
            idGenerator: databaseContext.idGenerator,
            platform: databaseContext.platform
        )
    }

    public func run<T: Sendable>(
        _ body: @Sendable (S) async throws -> T
    ) async throws -> T {
        try await executor.database.withConnection { connection in
            let context = DatabaseQueryContext(
                platform: platform,
                connection: connection,
                idGenerator: idGenerator
            )
            return try await body(executor.scope(context))
        }
    }

    public func run<T: Sendable>(
        _ body: @Sendable (S, any QueryContext) async throws -> T
    ) async throws -> T {
        try await executor.database.withConnection { connection in
            let context = DatabaseQueryContext(
                platform: platform,
                connection: connection,
                idGenerator: idGenerator
            )
            return try await body(
                executor.scope(context),
                context
            )
        }
    }
}
