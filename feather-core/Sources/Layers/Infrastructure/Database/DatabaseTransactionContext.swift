//
//  DatabaseTransactionContext.swift
//  feather-core
//

public import FeatherContracts
public import FeatherDatabase
public import FeatherDomain

public struct DatabaseTransactionContext: TransactionContext, DatabaseContext {

    public let connection: any DatabaseConnection
    public let idGenerator: any IDGenerator

    public init(
        connection: any DatabaseConnection,
        idGenerator: any IDGenerator
    ) {
        self.connection = connection
        self.idGenerator = idGenerator
    }
}
