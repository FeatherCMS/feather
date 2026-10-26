//
//  Table+Migration.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import FeatherDBAL
public import FeatherDatabase
public import FeatherInfrastructure
import UserModule

public struct TableMigration: DatabaseMigration {

    public let connection: any DatabaseConnection
    public let platform: any DatabasePlatform

    public init(
        connection: any DatabaseConnection,
        platform: any DatabasePlatform
    ) {
        self.connection = connection
        self.platform = platform
    }

    public func apply(
        on connection: any DatabaseConnection
    ) async throws {
        let schemas = [
            Identity.Table.tableCreationSchema,
            Role.Table.tableCreationSchema,
            IdentityRole.Table.tableCreationSchema,
        ]

        for schema in schemas {
            let queryBuilder = DatabaseQueryCreate(
                schema: schema,
                using: platform
            )
            for query in queryBuilder.build() {
                try await connection.run(query: query) { _ in }
            }
        }
    }
}
