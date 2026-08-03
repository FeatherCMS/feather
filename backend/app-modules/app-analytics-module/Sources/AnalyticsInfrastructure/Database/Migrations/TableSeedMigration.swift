//
//  TableSeedMigration.swift
//  app-analytics-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherDatabase
import Infrastructure

public struct TableSeedMigration: DatabaseMigration {

    public let connection: any DatabaseConnection

    public init(connection: any DatabaseConnection) {
        self.connection = connection
    }

    public func apply(
        on connection: any DatabaseConnection
    ) async throws { _ = connection }
}
