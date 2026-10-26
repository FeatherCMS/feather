public import AuthApplication
public import AuthModule
import FeatherApplication
import FeatherDBAL
import FeatherDatabase
public import FeatherInfrastructure
import Foundation

extension RolePermission.Search.Query.Database {
    private struct Row {
        let roleId: String
        let permissionId: String
        let createdAt: Date
        let updatedAt: Date

        init(from row: any DatabaseRow) throws {
            roleId = try row.decode(column: "role_id", as: String.self)
            permissionId = try row.decode(
                column: "permission_key",
                as: String.self
            )
            createdAt = try row.decode(column: "created_at", as: Date.self)
            updatedAt = try row.decode(column: "updated_at", as: Date.self)
        }

        var output: RolePermission.Search.Output.Item {
            .init(
                roleId: roleId,
                permissionId: permissionId,
                createdAt: createdAt,
                updatedAt: updatedAt
            )
        }
    }
}

extension RolePermission.Search.Query {
    public struct Database: Interface {

        public let context: DatabaseQueryContext

        public init(context: DatabaseQueryContext) {
            self.context = context
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
            _ query: RolePermission.Search.Input.Query
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

        public func search(
            query: RolePermission.Search.Input.Query
        ) async throws -> RolePermission.Search.Output {
            let search = query.search
            let page = query.page.normalized()
            let pageIndex = page.number - 1
            let offset =
                pageIndex > Int.max / page.size
                ? Int.max
                : pageIndex * page.size
            let orderBy = orderByRolePermission(query)

            let items = try await context.connection.run(
                query: #"""
                    SELECT arp.role_id, sp.key AS permission_key,
                        arp.created_at, arp.updated_at
                    FROM auth_role_permission AS arp
                    INNER JOIN system_permission AS sp ON sp.id = arp.permission_id
                    WHERE (\#(search == nil)
                        OR LOWER(arp.role_id) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                        OR LOWER(sp.key) LIKE '%' || LOWER(\#(search ?? "")) || '%')
                    ORDER BY \#(unescaped: orderBy)
                    LIMIT \#(page.size) OFFSET \#(offset);
                    """#
            ) { rows in
                try await rows.collect().map { try Row(from: $0).output }
            }

            return .init(items: items)
        }

        public func count(
            query: RolePermission.Search.Input.Query
        ) async throws -> Int {
            try await context.connection.run(
                query: #"""
                    SELECT COUNT(*) AS count
                    FROM auth_role_permission AS arp
                    INNER JOIN system_permission AS sp ON sp.id = arp.permission_id
                    WHERE (\#(query.search == nil)
                        OR LOWER(arp.role_id) LIKE '%' || LOWER(\#(query.search ?? "")) || '%'
                        OR LOWER(sp.key) LIKE '%' || LOWER(\#(query.search ?? "")) || '%');
                    """#
            ) { rows in
                guard let row = try await rows.collect().first else { return 0 }
                return try row.decode(column: "count", as: Int.self)
            }
        }
    }
}
