//
//  RolePermissionDatabaseRepository.swift
//  app-auth-module
//
//  Created by Binary Birds on 2026. 06. 18.

import AuthDomain
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure

import struct Foundation.Date

extension RolePermissionTable.Row {
    var asDomain: RolePermission {
        .init(
            roleId: roleId,
            permissionId: permissionId,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

public struct RolePermissionDatabaseRepository: RolePermissionRepository {

    public let context: DatabaseTransactionContext

    public init(context: DatabaseTransactionContext) {
        self.context = context
    }

    public func findBy(
        roleId: String,
        permissionId: String
    ) async throws -> RolePermission? {
        let table = RolePermissionTable(connection: context.connection)
        return try await table.find(
            roleId: roleId,
            permissionId: permissionId
        )?
        .asDomain
    }

    public func insert(
        _ model: RolePermission.New
    ) async throws -> RolePermission {
        let table = RolePermissionTable(connection: context.connection)
        let saved = try await table.save(
            row: .init(
                roleId: model.roleId,
                permissionId: model.permissionId,
                createdAt: .init(timeIntervalSince1970: 0),
                updatedAt: .init(timeIntervalSince1970: 0)
            )
        )
        return saved.asDomain
    }

    public func update(
        roleId: String,
        permissionId: String,
        _ model: RolePermission.New
    ) async throws -> RolePermission {
        let table = RolePermissionTable(connection: context.connection)
        let updated = try await table.update(
            roleId: roleId,
            permissionId: permissionId,
            row: .init(
                roleId: model.roleId,
                permissionId: model.permissionId,
                createdAt: .init(timeIntervalSince1970: 0),
                updatedAt: .init(timeIntervalSince1970: 0)
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
        let table = RolePermissionTable(connection: context.connection)
        var removed = true
        for id in ids {
            let parts = id.split(separator: ":", maxSplits: 1).map(String.init)
            guard parts.count == 2 else {
                removed = false
                continue
            }
            removed = try await table.delete(
                roleId: parts[0],
                permissionId: parts[1]
            ) && removed
        }
        return removed
    }
}
