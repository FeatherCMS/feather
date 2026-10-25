import FeatherDBAL
public import FeatherInfrastructure
public import UserApplication
import UserDomain
public import UserModule

private struct IdentityListRoleName: DatabaseTableRowDecodable {
    let name: String?
}

extension Identity.List.Query {
    public struct Database: Interface {
        private let context: DatabaseQueryContext
        private let accessLayer: DatabaseAccessLayer<Identity.Table>

        public init(context: DatabaseQueryContext) {
            self.context = context
            self.accessLayer = .init(context: context)
        }

        public func list(query: Identity.List.Input.Query) async throws
            -> Identity.List.Output
        {
            let roleIDs = try await matchingRoleIDs(query.role)
            if let roleIDs, roleIDs.isEmpty {
                return .init(items: [])
            }

            let rows = try await accessLayer.select(
                as: Identity.Table.List.self
            ) { initial in
                applyFilters(query, roleIDs: roleIDs, to: initial)
                    .order(by: [.init(by: \.id, .ascending)])
                    .limit(min(max(query.limit ?? 20, 1), 100))
            }

            var items: [Identity.List.Output.Item] = []
            for row in rows {
                items.append(
                    .init(
                        id: row.id,
                        name: row.name,
                        status: Identity.Model.Status(rawValue: row.status)
                            ?? .deactivated,
                        roles: try await roleNames(identityID: row.id)
                    )
                )
            }
            return .init(items: items)
        }

        private func applyFilters(
            _ query: Identity.List.Input.Query,
            roleIDs: [String]?,
            to initial: DatabaseQuerySelect<Identity.Table>
        ) -> DatabaseQuerySelect<Identity.Table> {
            var result = initial
            if let search = query.search {
                result = result.where(
                    searchText: search,
                    columns: [\.id, \.name, \.status]
                )
            }
            if let roleIDs {
                result = result.where(\.id, in: roleIDs)
            }
            return result
        }

        private func matchingRoleIDs(_ role: String?) async throws
            -> [String]?
        {
            guard let role else { return nil }
            let matchingRoles = try await DatabaseAccessLayer<Role.Table>(
                context: context
            )
            .select(as: Role.Table.List.self) { query in
                query.where(
                    searchText: role,
                    columns: [
                        DatabaseQueryTextColumn<Role.Table>(\.id),
                        DatabaseQueryTextColumn<Role.Table>(\.name),
                    ],
                    matching: .exact
                )
            }
            let roleIDs = matchingRoles.map(\.id)
            guard !roleIDs.isEmpty else { return [] }
            return try await DatabaseAccessLayer<IdentityRole.Table>(
                context: context
            )
            .select(as: IdentityRole.Table.IdentityID.self) {
                $0.where(\.roleId, in: roleIDs)
            }
            .map(\.identityId)
        }

        private func roleNames(identityID: String) async throws -> [String] {
            let roleIDs = try await DatabaseAccessLayer<
                IdentityRole.Table
            >(
                context: context
            )
            .select(as: IdentityRole.Table.RoleID.self) {
                $0.where(\.identityId, equals: identityID)
            }
            .map(\.roleId)
            guard !roleIDs.isEmpty else { return [] }
            return try await DatabaseAccessLayer<Role.Table>(context: context)
                .select(as: IdentityListRoleName.self) { query in
                    query.where(\.id, in: roleIDs)
                        .columns(query.table.column(\.name))
                }
                .compactMap(\.name)
                .sorted()
        }
    }
}
