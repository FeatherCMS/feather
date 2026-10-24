//
//  DatabaseTransactionContext.swift
//  feather-core
//

public import FeatherModuleKit
public import FeatherDBAL
public import FeatherDatabase
public import FeatherDomain

public struct DatabaseTransactionContext: TransactionContext, DatabaseContext {

    public let platform: any DatabasePlatform
    public let connection: any DatabaseConnection
    public let idGenerator: any IDGenerator

    public init(
        platform: any DatabasePlatform,
        connection: any DatabaseConnection,
        idGenerator: any IDGenerator
    ) {
        self.platform = platform
        self.connection = connection
        self.idGenerator = idGenerator
    }
}
