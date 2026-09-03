//
//  IdentityDatabaseQueries.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherApplication
import FeatherContracts
import FeatherDatabase
import FeatherInfrastructure
import UserApplication

extension IdentityTable.Row {

    var asIdentityStatus: IdentityStatus {
        .init(rawValue: status) ?? .deactivated
    }

    func asQueryListItem(
        roles: [String]
    ) -> IdentityList.Item {
        .init(
            id: id,
            name: name,
            status: asIdentityStatus,
            roles: roles,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }

    var asDetail: IdentityDetail {
        .init(
            id: id,
            name: name,
            status: asIdentityStatus,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

public struct IdentityDatabaseQueries: IdentityQueries {

    public let context: DatabaseQueryContext

    public init(context: DatabaseQueryContext) {
        self.context = context
    }

    private func pageSizeOffset(
        _ page: Search.Page
    ) -> (size: Int, offset: Int) {
        let size = max(1, page.size)
        let number = max(1, page.number)
        return (size, (number - 1) * size)
    }

    private func sortDirectionSQL(
        _ direction: Search.SortDirection
    ) -> String {
        switch direction {
        case .asc:
            "ASC"
        case .desc:
            "DESC"
        }
    }

    private func orderBySystemIdentity(
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

    public func getBy(
        id: String
    ) async throws -> IdentityDetail {
        let table = IdentityTable(connection: context.connection)
        guard let row = try await table.find(id: id) else {
            throw RepositoryError.notFound
        }
        return row.asDetail
    }

    public func getRolesBy(
        identityId: String
    ) async throws -> [String] {
        let table = IdentityTable(connection: context.connection)
        return try await table.listRoleNames(identityId: identityId)
    }

    public func getRoleIdsBy(
        identityId: String
    ) async throws -> [String] {
        let table = IdentityTable(connection: context.connection)
        return try await table.listRoleIds(identityId: identityId)
    }

    public func getPermissionsBy(
        identityId: String
    ) async throws -> [String] {
        let table = IdentityTable(connection: context.connection)
        return try await table.listPermissionNames(identityId: identityId)
    }

    public func list(
        query: IdentityList.Query
    ) async throws -> IdentityList {
        let search = query.search
        let page = pageSizeOffset(query.page)
        let orderBy = orderBySystemIdentity(query)

        let table = IdentityTable(connection: context.connection)
        let rows = try await table.list(
            search: search,
            role: query.role,
            orderBy: orderBy,
            limit: page.size,
            offset: page.offset
        )
        var items: [IdentityList.Item] = []
        for row in rows {
            items.append(
                row.asQueryListItem(
                    roles: try await table.listRoleNames(identityId: row.id)
                )
            )
        }

        return .init(items: items)
    }

    public func count(
        query: IdentityList.Query
    ) async throws -> Int {
        let table = IdentityTable(connection: context.connection)
        return try await table.count(search: query.search, role: query.role)
    }
}
