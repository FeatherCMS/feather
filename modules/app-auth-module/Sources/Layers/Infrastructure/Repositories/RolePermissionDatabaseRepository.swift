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
    func asDomain(permissionKey: String? = nil) -> RolePermission {
        .init(
            roleId: roleId,
            permissionId: permissionKey ?? self.permissionKey ?? permissionId,
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

    private func permissionID(forKey key: String) async throws -> String {
        try await context.connection.run(
            query: #"""
                SELECT id
                FROM system_permission
                WHERE key=\#(key)
                LIMIT 1;
                """#
        ) { sequence in
            guard let row = try await sequence.collect().first else {
                throw RepositoryError.notFound
            }
            return try row.decode(column: "id", as: String.self)
        }
    }

    public func findBy(
        roleId: String,
        permissionId: String
    ) async throws -> RolePermission? {
        let table = RolePermissionTable(connection: context.connection)
        let databasePermissionID = try await permissionID(forKey: permissionId)
        return try await table.find(
            roleId: roleId,
            permissionId: databasePermissionID
        )?
        .asDomain(permissionKey: permissionId)
    }

    public func insert(
        _ model: RolePermission.New
    ) async throws -> RolePermission {
        let table = RolePermissionTable(connection: context.connection)
        let databasePermissionID = try await permissionID(
            forKey: model.permissionId
        )
        let saved = try await table.save(
            row: .init(
                roleId: model.roleId,
                permissionId: databasePermissionID,
                permissionKey: model.permissionId,
                createdAt: .init(timeIntervalSince1970: 0),
                updatedAt: .init(timeIntervalSince1970: 0)
            )
        )
        return saved.asDomain(permissionKey: model.permissionId)
    }

    public func update(
        roleId: String,
        permissionId: String,
        _ model: RolePermission.New
    ) async throws -> RolePermission {
        let table = RolePermissionTable(connection: context.connection)
        let oldDatabasePermissionID = try await permissionID(
            forKey: permissionId
        )
        let newDatabasePermissionID = try await permissionID(
            forKey: model.permissionId
        )
        let updated = try await table.update(
            roleId: roleId,
            permissionId: oldDatabasePermissionID,
            row: .init(
                roleId: model.roleId,
                permissionId: newDatabasePermissionID,
                permissionKey: model.permissionId,
                createdAt: .init(timeIntervalSince1970: 0),
                updatedAt: .init(timeIntervalSince1970: 0)
            )
        )
        guard let updated else {
            throw RepositoryError.notFound
        }
        return updated.asDomain(permissionKey: model.permissionId)
    }

    public func delete(
        ids: [String]
    ) async throws -> [String] {
        let table = RolePermissionTable(connection: context.connection)
        var databaseIDs: [String] = []
        var databaseToExternal: [String: String] = [:]
        for value in ids {
            let parts = value.split(separator: ":", maxSplits: 1)
                .map(String.init)
            guard parts.count == 2 else { continue }
            let databasePermissionID = try await permissionID(forKey: parts[1])
            let databaseValue = "\(parts[0]):\(databasePermissionID)"
            databaseIDs.append(databaseValue)
            databaseToExternal[databaseValue] = value
        }
        return try await table.delete(ids: databaseIDs)
            .compactMap {
                databaseToExternal[$0]
            }
    }
}
