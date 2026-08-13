//
//  SettingsDatabaseRepository.swift
//  app-account-module
//
//  Created by Binary Birds on 2026. 07. 16.

import AccountApplication
import AccountDomain
import FeatherApplication
import FeatherContracts
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure

public struct SettingsDatabaseRepository: SettingsRepository {

    public let context: DatabaseTransactionContext
    public init(context: DatabaseTransactionContext) {
        self.context = context
    }

    public func get(
        userId: String
    ) async throws -> Settings {
        let row = try await SettingsTable(connection: context.connection)
            .get(userId: userId)
        return try row.asDomain
    }

    public func getOrCreate(
        userId: String
    ) async throws -> Settings {
        do {
            return try await get(userId: userId)
        }
        catch let error as RepositoryError
        where error.reason == .database(.notFound) {
            try await create(userId: userId)
            return try await get(userId: userId)
        }
    }

    public func create(
        userId: String
    ) async throws {
        let new = try Settings.create(
            userId: userId
        )
        _ = try await SettingsTable(connection: context.connection)
            .create(
                row: .init(
                    id: context.idGenerator.generate(),
                    userId: new.userId,
                    language: new.language,
                    timezone: new.timezone,
                    pageSize: new.pageSize
                )
            )
    }

    public func update(
        _ model: Settings
    ) async throws -> Settings {
        let row = try await SettingsTable(connection: context.connection)
            .update(
                userId: model.userId,
                row: .init(
                    userId: model.userId,
                    language: model.language,
                    timezone: model.timezone,
                    pageSize: model.pageSize
                )
            )
        return try row.asDomain
    }

    public func delete(
        userId: String
    ) async throws {
        try await SettingsTable(connection: context.connection)
            .delete(userId: userId)
    }
}

extension SettingsTable.Row {

    fileprivate var asDomain: Settings {
        get throws {
            .init(
                userId: userId,
                language: language,
                timezone: timezone,
                pageSize: pageSize,
                createdAt: createdAt,
                updatedAt: updatedAt
            )
        }
    }
}
