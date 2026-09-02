//
//  MenuDatabaseRepository.swift
//  app-web-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import WebDomain

extension MenuTable.Row {
    var asDomain: Menu {
        .init(
            id: id,
            key: key,
            name: name,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

public struct MenuDatabaseRepository: MenuRepository {

    public let context: DatabaseTransactionContext
    public init(context: DatabaseTransactionContext) {
        self.context = context
    }

    public func insert(
        _ model: Menu.New
    ) async throws -> Menu {
        let table = MenuTable(connection: context.connection)
        let saved = try await table.create(
            row: .init(
                id: context.idGenerator.generate(),
                key: model.key,
                name: model.name,
                notes: model.notes
            )
        )
        return saved.asDomain
    }

    public func find(
        id: String
    ) async throws -> Menu? {
        let table = MenuTable(connection: context.connection)
        return try await table.find(id: id)?.asDomain
    }

    public func find(
        key: String
    ) async throws -> Menu? {
        let table = MenuTable(connection: context.connection)
        return try await table.find(key: key)?.asDomain
    }

    public func update(
        _ model: Menu
    ) async throws -> Menu {
        let table = MenuTable(connection: context.connection)
        let updated = try await table.update(
            id: model.id,
            row: .init(
                id: model.id,
                key: model.key,
                name: model.name,
                notes: model.notes,
                createdAt: model.createdAt,
                updatedAt: model.updatedAt
            )
        )
        return updated.asDomain
    }

    public func delete(
        ids: [String]
    ) async throws -> [String] {
        let table = MenuTable(connection: context.connection)
        return try await table.delete(ids: ids)
    }
}
