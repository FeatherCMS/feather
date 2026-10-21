import FeatherApplication
import FeatherDBAL
public import FeatherInfrastructure
public import UserApplication
import UserDomain
public import UserModule

private struct IdentitySearchRoleName: DatabaseTableRowDecodable {
    let name: String?
}

extension Identity.Table.Row {
    var asIdentityStatus: Identity.Model.Status {
        .init(rawValue: status) ?? .deactivated
    }

    func asSearchItem(roles: [String]) -> Identity.Search.Output.Item {
        .init(
            id: id,
            name: name,
            status: asIdentityStatus,
            roles: roles,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

extension Identity.Search {
    public struct Database: Identity.Search.Interface {
        public let context: DatabaseQueryContext

        public init(context: DatabaseQueryContext) {
            self.context = context
        }

        public func search(query: Identity.Search.Input.Query) async throws
            -> Identity.Search.Output
        {
            let matchingIdentityIDs = try await identityIDs(
                matching: query.role
            )
            if let matchingIdentityIDs, matchingIdentityIDs.isEmpty {
                return .init(items: [], total: 0)
            }

            let accessLayer = DatabaseAccessLayer<Identity.Table>(
                context: context
            )
            let rows = try await accessLayer.select(as: Identity.Table.Row.self)
            { initial in
                var result = initial
                if let search = query.search {
                    result = result.where(
                        searchText: search,
                        columns: [\.id, \.name, \.status]
                    )
                }
                if let matchingIdentityIDs {
                    result = result.where(\.id, in: matchingIdentityIDs)
                }
                return paginated(
                    result.order(by: databaseOrders(query.sort)),
                    page: query.page
                )
            }

            var items: [Identity.Search.Output.Item] = []
            for row in rows {
                items.append(
                    row.asSearchItem(
                        roles: try await roleNames(identityId: row.id)
                    )
                )
            }

            let total = try await accessLayer.selectCount { initial in
                var result = initial
                if let search = query.search {
                    result = result.where(
                        searchText: search,
                        columns: [\.id, \.name, \.status]
                    )
                }
                if let matchingIdentityIDs {
                    result = result.where(\.id, in: matchingIdentityIDs)
                }
                return result
            }
            return .init(items: items, total: total)
        }

        private func roleNames(identityId: String) async throws -> [String] {
            let links = try await DatabaseAccessLayer<Identity.Table.RoleLink>(
                context: context
            )
            .select(as: Identity.Table.RoleLink.Row.self) {
                $0.where(\.identityId, equals: identityId)
            }
            let roleIDs = links.map(\.roleId)
            guard !roleIDs.isEmpty else { return [] }
            return try await DatabaseAccessLayer<Role.Table>(context: context)
                .select(as: IdentitySearchRoleName.self) { query in
                    query.where(\.id, in: roleIDs)
                        .columns(query.table.column(\.name))
                }
                .compactMap(\.name)
                .sorted()
        }

        private func identityIDs(matching role: String?) async throws
            -> [String]?
        {
            guard let role else { return nil }

            let roleRows = try await DatabaseAccessLayer<Role.Table>(
                context: context
            )
            .select(as: Role.Table.Row.self) { initial in
                initial.where(
                    searchText: role,
                    columns: [
                        DatabaseQueryTextColumn<Role.Table>(\.id),
                        DatabaseQueryTextColumn<Role.Table>(\.name),
                    ],
                    matching: .exact
                )
            }
            let roleIDs = roleRows.map(\.id)
            guard !roleIDs.isEmpty else { return [] }

            return try await DatabaseAccessLayer<Identity.Table.RoleLink>(
                context: context
            )
            .select(as: Identity.Table.RoleLink.IdentityID.self) {
                $0.where(\.roleId, in: roleIDs)
            }
            .map(\.identityId)
        }

        private func databaseOrders(
            _ rules: [Identity.Search.Input.Query.Sort]
        ) -> [DatabaseQueryOrder<Identity.Table>] {
            var orders = rules.map { rule in
                DatabaseQueryOrder<Identity.Table>(
                    by: \.id,
                    rule.direction == .asc ? .ascending : .descending
                )
            }
            if !rules.contains(where: { $0.field == .id }) {
                orders.append(DatabaseQueryOrder<Identity.Table>(by: \.id))
            }
            return orders
        }

        private func paginated(
            _ query: DatabaseQuerySelect<Identity.Table>,
            page: Search.Page
        ) -> DatabaseQuerySelect<Identity.Table> {
            let page = page.normalized()
            let pageIndex = page.number - 1
            let offset =
                pageIndex > Int.max / page.size
                ? Int.max : pageIndex * page.size
            return query.limit(page.size).offset(offset)
        }
    }
}
