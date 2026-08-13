//
//  PermissionDatabaseRepository.swift
//  app-system-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import SystemDomain

extension PermissionTable.Row {
    var asDomain: Permission {
        .init(
            id: id,
            name: name,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

public struct PermissionDatabaseRepository: PermissionRepository {

    public let context: DatabaseTransactionContext

    public init(context: DatabaseTransactionContext) {
        self.context = context
    }

    public func insert(
        _ model: Permission.New
    ) async throws -> Permission {
        let table = PermissionTable(connection: context.connection)
        let saved = try await table.create(
            row: .init(
                id: model.id,
                name: model.name,
                notes: model.notes
            )
        )
        return saved.asDomain
    }

    public func update(
        _ model: Permission
    ) async throws -> Permission {
        let table = PermissionTable(connection: context.connection)
        let updated = try await table.update(
            id: model.id,
            row: .init(
                id: model.id,
                name: model.name,
                notes: model.notes,
                createdAt: model.createdAt,
                updatedAt: model.createdAt
            )
        )
        return updated.asDomain
    }

    public func find(
        id: String
    ) async throws -> Permission? {
        let table = PermissionTable(connection: context.connection)
        return try await table.find(id: id)?.asDomain
    }

    public func delete(
        id: String
    ) async throws -> Bool {
        let table = PermissionTable(connection: context.connection)
        return try await table.delete(id: id)
    }
}
