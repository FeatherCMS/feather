import AuthApplication
import FeatherDatabase
import Application

extension RolePermissionTable.Row {

    var asQueryListItem: RolePermissionList.Item {
        .init(
            roleId: roleId,
            permissionId: permissionId,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }

    var asDetail: RolePermissionDetail {
        .init(
            roleId: roleId,
            permissionId: permissionId,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

public struct DatabaseRolePermissionQueries: RolePermissionQueries {

    public var connection: any DatabaseConnection

    public init(
        connection: any DatabaseConnection
    ) {
        self.connection = connection
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

    private func orderByRolePermission(
        _ query: RolePermissionList.Query
    ) -> String {
        let sortParts = query.sort.map { rule -> String in
            let column: String
            switch rule.field {
            case .roleId:
                column = "role_id"
            case .permissionId:
                column = "permission_id"
            }
            return "\(column) \(sortDirectionSQL(rule.direction))"
        }
        return (sortParts + ["role_id ASC", "permission_id ASC"])
            .joined(
                separator: ", "
            )
    }

    public func permissions(
        for roleIds: Set<String>
    ) async throws -> Set<String> {
        guard !roleIds.isEmpty else {
            return []
        }

        let table = RolePermissionTable(connection: connection)
        var result: Set<String> = []
        for roleId in roleIds {
            let permissionIds = try await table.listPermissionIds(
                roleId: roleId
            )
            result.formUnion(permissionIds)
        }
        return result
    }

    public func getBy(
        roleId: String,
        permissionId: String
    ) async throws -> RolePermissionDetail {
        let table = RolePermissionTable(connection: connection)
        guard
            let row = try await table.find(
                roleId: roleId,
                permissionId: permissionId
            )
        else {
            fatalError()
        }
        return row.asDetail
    }

    public func list(
        query: RolePermissionList.Query
    ) async throws -> RolePermissionList {
        let search = query.search
        let page = pageSizeOffset(query.page)
        let orderBy = orderByRolePermission(query)

        let table = RolePermissionTable(connection: connection)
        let items =
            try await table.list(
                search: search,
                orderBy: orderBy,
                limit: page.size,
                offset: page.offset
            )
            .map(\.asQueryListItem)

        return .init(items: items)
    }

    public func count(
        query: RolePermissionList.Query
    ) async throws -> Int {
        let table = RolePermissionTable(connection: connection)
        return try await table.count(search: query.search)
    }
}
