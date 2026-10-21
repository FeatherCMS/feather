//
//  Identity.Query.Database.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherApplication
import FeatherDBAL
public import FeatherInfrastructure
public import UserApplication
import UserDomain
public import UserModule

extension Identity.Table.Row {

    var asIdentityStatus: Identity.Model.Status {
        .init(rawValue: status) ?? .deactivated
    }

    func asQueryListItem(
        roles: [String]
    ) -> Identity.Search.Output.Item {
        .init(
            id: id,
            name: name,
            status: asIdentityStatus,
            roles: roles,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }

    var asDetail: Identity.Detail.Output {
        .init(
            id: id,
            name: name,
            status: asIdentityStatus,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

extension Identity.Query {
    public struct Database: Identity.Query.Interface {

        public let context: DatabaseQueryContext

        public init(context: DatabaseQueryContext) {
            self.context = context
        }

        private func pageSizeOffset(
            _ page: Search.Page
        ) -> (size: Int, offset: Int) {
            let page = page.normalized()
            let pageIndex = page.number - 1
            let offset =
                pageIndex > Int.max / page.size
                ? Int.max
                : pageIndex * page.size
            return (page.size, offset)
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
            _ query: Identity.Search.Input.Query
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
        ) async throws -> Identity.Detail.Output {
            let table = Identity.Table(connection: context.connection)
            guard let row = try await table.find(id: id) else {
                throw RepositoryError.notFound
            }
            return row.asDetail
        }

        public func getRolesBy(
            identityId: String
        ) async throws -> [String] {
            let table = Identity.Table(connection: context.connection)
            return try await table.listRoleNames(identityId: identityId)
        }

        public func getRoleIdsBy(
            identityId: String
        ) async throws -> [String] {
            let table = Identity.Table(connection: context.connection)
            return try await table.listRoleIds(identityId: identityId)
        }

        public func getPermissionsBy(
            identityId: String
        ) async throws -> [String] {
            let table = Identity.Table(connection: context.connection)
            return try await table.listPermissionNames(identityId: identityId)
        }

        public func search(
            query: Identity.Search.Input.Query
        ) async throws -> Identity.Search.Output {
            let search = query.search
            let page = pageSizeOffset(query.page)
            let orderBy = orderBySystemIdentity(query)

            let table = Identity.Table(connection: context.connection)
            let rows = try await table.list(
                search: search,
                role: query.role,
                orderBy: orderBy,
                limit: page.size,
                offset: page.offset
            )
            var items: [Identity.Search.Output.Item] = []
            for row in rows {
                items.append(
                    row.asQueryListItem(
                        roles: try await table.listRoleNames(identityId: row.id)
                    )
                )
            }

            let total = try await table.count(search: search, role: query.role)
            return .init(items: items, total: total)
        }
    }
}
