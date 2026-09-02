//
//  IdentityDatabaseRepository.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherApplication
import FeatherContracts
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import UserApplication
import UserDomain

extension IdentityTable.Row {
    var asDomain: Identity {
        get throws {
            guard let status = Identity.Status(rawValue: status) else {
                throw RepositoryError.invalidEnumValue(status)
            }
            return .init(
                id: id,
                status: status,
                isRoot: isRoot,
                createdAt: createdAt,
                updatedAt: updatedAt
            )
        }
    }
}

public struct IdentityDatabaseRepository: IdentityRepository {

    public let context: DatabaseTransactionContext
    public init(context: DatabaseTransactionContext) {
        self.context = context
    }

    func pageSizeOffset(
        _ page: Search.Page
    ) -> (size: Int, offset: Int) {
        let size = max(1, page.size)
        let number = max(1, page.number)
        return (size, (number - 1) * size)
    }

    func sortDirectionSQL(
        _ direction: Search.SortDirection
    ) -> String {
        switch direction {
        case .asc:
            "ASC"
        case .desc:
            "DESC"
        }
    }

    func orderByUserIdentity(
        _ query: IdentityList.Query
    ) -> String {
        let sortParts = query.sort.map { rule -> String in
            let column: String
            switch rule.field {
            case .id:
                column = "id"
            }
            return "\(column) \(sortDirectionSQL(rule.direction))"
        }
        return (sortParts + ["id ASC"]).joined(separator: ", ")
    }

    // MARK: -

    public func insert(
        _ model: Identity.New
    ) async throws -> Identity {
        try await insert(id: context.idGenerator.generate(), model: model)
    }

    public func insert(
        id: String,
        model: Identity.New
    ) async throws -> Identity {
        let table = IdentityTable(connection: context.connection)
        let saved = try await table.save(
            row: .init(
                id: id,
                status: model.status.rawValue,
                isRoot: model.isRoot
            )
        )
        return try saved.asDomain
    }

    public func listUserIdentities(
        query: IdentityList.Query
    ) async throws -> [Identity] {
        let search = query.search
        let page = pageSizeOffset(query.page)
        let orderBy = orderByUserIdentity(query)

        let table = IdentityTable(connection: context.connection)
        return
            try await table.list(
                search: search,
                orderBy: orderBy,
                limit: page.size,
                offset: page.offset
            )
            .map { try $0.asDomain }
    }

    public func countUserIdentities(
        query: IdentityList.Query
    ) async throws -> Int {
        let search = query.search
        let table = IdentityTable(connection: context.connection)
        return try await table.count(search: search)
    }

    public func findBy(
        id: String
    ) async throws -> Identity? {
        let table = IdentityTable(connection: context.connection)
        return try await table.find(id: id)?.asDomain
    }

    public func findRoot() async throws -> Identity? {
        let table = IdentityTable(connection: context.connection)
        return try await table.findRoot()?.asDomain
    }

    public func findRolesBy(
        identityId: String
    ) async throws -> [String] {
        let table = IdentityTable(connection: context.connection)
        return try await table.listRoleNames(identityId: identityId)
    }

    public func findRoleIdsBy(
        identityId: String
    ) async throws -> [String] {
        let table = IdentityTable(connection: context.connection)
        return try await table.listRoleIds(identityId: identityId)
    }

    public func findPermissionsBy(
        identityId: String
    ) async throws -> [String] {
        let table = IdentityTable(connection: context.connection)
        return try await table.listPermissionNames(identityId: identityId)
    }

    public func update(
        _ model: Identity
    ) async throws -> Identity {
        let table = IdentityTable(connection: context.connection)
        let rowId = model.id
        let updated = try await table.update(
            id: rowId,
            row: .init(
                id: model.id,
                status: model.status.rawValue,
                isRoot: model.isRoot,
                createdAt: model.createdAt,
                updatedAt: model.updatedAt
            )
        )
        guard let updated else {
            throw RepositoryError.notFound
        }
        return try updated.asDomain
    }

    public func replaceRoleIds(
        identityId: String,
        roleIds: [String]
    ) async throws {
        let table = IdentityTable(connection: context.connection)
        try await table.replaceRoleIds(identityId: identityId, roleIds: roleIds)
    }

    public func delete(
        ids: [String]
    ) async throws -> Bool {
        let table = IdentityTable(connection: context.connection)
        var removed = true
        for id in ids {
            removed = try await table.delete(id: id) && removed
        }
        return removed
    }
}
