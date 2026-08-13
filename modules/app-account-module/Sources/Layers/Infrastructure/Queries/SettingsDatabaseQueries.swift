//
//  SettingsDatabaseQueries.swift
//  app-account-module
//
//  Created by Binary Birds on 2026. 07. 16.

import AccountApplication
import AccountDomain
import FeatherDatabase
import FeatherInfrastructure

public struct SettingsDatabaseQueries: SettingsQueries {

    public let context: DatabaseQueryContext

    public init(context: DatabaseQueryContext) {
        self.context = context
    }

    public func get(
        userId: String
    ) async throws -> Settings {
        let row = try await SettingsTable(connection: context.connection)
            .get(userId: userId)
        return .init(
            userId: row.userId,
            language: row.language,
            timezone: row.timezone,
            pageSize: row.pageSize,
            createdAt: row.createdAt,
            updatedAt: row.updatedAt
        )
    }
}
