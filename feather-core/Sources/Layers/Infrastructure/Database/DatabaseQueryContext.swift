//
//  DatabaseQueryContext.swift
//  feather-core
//

import FeatherApplication
import FeatherContracts
import FeatherDatabase

public struct DatabaseQueryContext: QueryContext, DatabaseContext {

    public let connection: any DatabaseConnection

    public init(
        connection: any DatabaseConnection
    ) {
        self.connection = connection
    }
}
