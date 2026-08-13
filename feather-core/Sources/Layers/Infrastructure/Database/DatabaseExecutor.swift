//
//  DatabaseExecutor.swift
//  feather-core
//

import FeatherApplication
import FeatherContracts
import FeatherDatabase

public struct DatabaseExecutor<S: Scope, C: ExecutionContext>: Sendable {

    public let database: any DatabaseClient
    public let scope: @Sendable (C) -> S

    public init(
        database: any DatabaseClient,
        scope: @Sendable @escaping (C) -> S
    ) {
        self.database = database
        self.scope = scope
    }
}
