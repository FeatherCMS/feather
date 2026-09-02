//
//  RoleDatabaseRepository.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import UserDomain

import struct Foundation.Date

extension RoleTable.Row {
    var asDomain: Role {
        .init(
            id: id,
            name: name,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

public struct RoleDatabaseRepository: RoleRepository {

    public let context: DatabaseTransactionContext

    public init(context: DatabaseTransactionContext) {
        self.context = context
    }

    public func findBy(
        id: String
    ) async throws -> Role? {
        let table = RoleTable(connection: context.connection)
        return try await table.find(id: id)?.asDomain
    }

    public func findBy(
        name: String
    ) async throws -> Role? {
        let table = RoleTable(connection: context.connection)
        return try await table.find(name: name)?.asDomain
    }

    public func insert(
        _ model: Role.New
    ) async throws -> Role {
        let table = RoleTable(connection: context.connection)
        let saved = try await table.save(
            row: .init(
                id: model.id,
                name: model.name,
                notes: model.notes,
                createdAt: .init(timeIntervalSince1970: 0),
                updatedAt: .init(timeIntervalSince1970: 0)
            )
        )
        return saved.asDomain
    }

    public func update(
        _ model: Role
    ) async throws -> Role {
        let table = RoleTable(connection: context.connection)
        let updated = try await table.update(
            id: model.id,
            row: .init(
                id: model.id,
                name: model.name,
                notes: model.notes,
                createdAt: model.createdAt,
                updatedAt: model.updatedAt
            )
        )
        guard let updated else {
            throw RepositoryError.notFound
        }
        return updated.asDomain
    }

    public func delete(
        ids: [String]
    ) async throws -> Bool {
        let table = RoleTable(connection: context.connection)
        var removed = true
        for id in ids {
            removed = try await table.delete(id: id) && removed
        }
        return removed
    }
}
