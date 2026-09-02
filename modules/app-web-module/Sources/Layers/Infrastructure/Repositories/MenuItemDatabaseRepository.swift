//
//  MenuItemDatabaseRepository.swift
//  app-web-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import WebDomain

extension MenuItemTable.Row {
    var asDomain: MenuItem {
        .init(
            id: id,
            menuId: menuId,
            label: label,
            url: url,
            priority: priority,
            isBlank: isBlank,
            permission: permission,
            authentication: authentication,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

public struct MenuItemDatabaseRepository: MenuItemRepository {

    public let context: DatabaseTransactionContext
    public init(context: DatabaseTransactionContext) {
        self.context = context
    }

    public func insert(
        _ model: MenuItem.New
    ) async throws -> MenuItem {
        let table = MenuItemTable(connection: context.connection)
        let saved = try await table.create(
            row: .init(
                id: context.idGenerator.generate(),
                menuId: model.menuId,
                label: model.label,
                url: model.url,
                priority: model.priority,
                isBlank: model.isBlank,
                permission: model.permission,
                authentication: model.authentication,
                notes: model.notes
            )
        )
        return saved.asDomain
    }

    public func find(
        id: String
    ) async throws -> MenuItem? {
        let table = MenuItemTable(connection: context.connection)
        return try await table.find(id: id)?.asDomain
    }

    public func update(
        _ model: MenuItem
    ) async throws -> MenuItem {
        let table = MenuItemTable(connection: context.connection)
        let updated = try await table.update(
            id: model.id,
            row: .init(
                id: model.id,
                menuId: model.menuId,
                label: model.label,
                url: model.url,
                priority: model.priority,
                isBlank: model.isBlank,
                permission: model.permission,
                authentication: model.authentication,
                notes: model.notes,
                createdAt: model.createdAt,
                updatedAt: model.updatedAt
            )
        )
        return updated.asDomain
    }

    public func move(
        id: String,
        menuId: String,
        beforeItemId: String?
    ) async throws {
        let table = MenuItemTable(connection: context.connection)
        try await table.move(
            id: id,
            menuId: menuId,
            beforeItemID: beforeItemId
        )
    }

    public func delete(
        ids: [String]
    ) async throws -> [String] {
        let table = MenuItemTable(connection: context.connection)
        return try await table.delete(ids: ids)
    }
}
