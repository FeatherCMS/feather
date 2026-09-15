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
            key: key,
            name: name,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

public struct PermissionDatabaseRepository: PermissionRepository {

    public let context: any DatabaseContext
    public let idGenerator: any IDGenerator

    public init(context: any DatabaseContext) {
        self.context = context
        self.idGenerator = NanoIDGenerator()
    }

    public init(context: DatabaseTransactionContext) {
        self.context = context
        self.idGenerator = context.idGenerator
    }

    public func insert(
        _ model: Permission.New
    ) async throws -> Permission {
        let table = PermissionTable(connection: context.connection)
        let saved = try await table.create(
            row: .init(
                id: idGenerator.generate(),
                key: model.key,
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
                key: model.key,
                name: model.name,
                notes: model.notes,
                createdAt: model.createdAt,
                updatedAt: model.createdAt
            )
        )
        return updated.asDomain
    }

    public func find(
        key: String
    ) async throws -> Permission? {
        let table = PermissionTable(connection: context.connection)
        return try await table.find(key: key)?.asDomain
    }

    public func find(
        id: String
    ) async throws -> Permission? {
        let table = PermissionTable(connection: context.connection)
        return try await table.find(id: id)?.asDomain
    }

    public func delete(
        ids: [String]
    ) async throws -> [String] {
        let table = PermissionTable(connection: context.connection)
        return try await table.delete(ids: ids)
    }
}
